#!/usr/bin/env python

import hashlib
import os
import shutil
import tempfile
import urllib.request
import urllib.error

OINKCODES = {
#    "vrt": "8c406fcebc33ebe051fb9a7a2bda3edc59f5d405",
    "etpro": "7971239645745924",
}

RELEASE_POINT = "/var/lib/puppet/data/snort/rules"

RULES_FILES = (
#    ("vrt-2.9.6.2", "http://www.snort.org/rules", "snortrules-snapshot-2962.tar.gz"),
#    ("vrt-2.9.7.0", "http://www.snort.org/rules", "snortrules-snapshot-2970.tar.gz"),
    ("etpro-1.1.0", "http://rules.emergingthreatspro.com/", "suricata-1.1.0/etpro.rules.tar.gz"),
)

def get_file(url, filename=None):
    response = urllib.request.urlopen(url)
    content = response.read()
    if filename is not None:
        with open(filename, "wb") as f:
            f.write(content)

    return content

def verify(filename, md5):
    hasher = hashlib.md5()
    with open(filename, "rb") as f:
        buf = f.read(1024)
        while len(buf) > 0:
            hasher.update(buf)
            buf = f.read(1024)

    newmd5 = hasher.hexdigest().encode("utf-8")
    if (md5.lower() != newmd5.lower()):
        print("[-] MD5 Mismatch: Expected {}, Got {}".format(md5, newmd5))
    return (md5.lower() == newmd5.lower())

def is_new_release(filename, md5):
    md5file = os.path.join(RELEASE_POINT, "{}.md5".format(filename))
    if not os.path.exists(md5file):
        return True

    oldmd5 = open(md5file, "rb").read().strip()
    return not (md5.lower() == oldmd5.lower())

def release(outfile, filename, md5):
    releasefile = os.path.join(RELEASE_POINT, filename)
    oldreleasefile = os.path.join(RELEASE_POINT, "{}.old".format(filename))
    md5releasefile = os.path.join(RELEASE_POINT, "{}.md5".format(filename))

    if os.path.exists(oldreleasefile):
        os.remove(oldreleasefile)

    # Copy releasefile to oldreleasefile
    if os.path.exists(releasefile):
        shutil.copyfile(releasefile, oldreleasefile)
        if os.path.exists(oldreleasefile):
            os.remove(releasefile)
        else:
            return False

    # Copy outfile to releasefile
    shutil.copyfile(outfile, releasefile)
    if not os.path.exists(releasefile):
        return False

    # Write MD5
    with open(md5releasefile, "wb") as f:
        f.write(md5)

    return True

tmpdir = tempfile.mkdtemp()
print("[+] Temp directory: {}".format(tmpdir))

try:
    for tag,base_url,filename in RULES_FILES:
        rules_type = tag.split("-")[0]
        OINKCODE = OINKCODES[rules_type]

        if tag.startswith("etpro"):
            url = "{}/{}/{}".format(base_url, OINKCODE, filename)
            md5url = "{}/{}/{}.md5".format(base_url, OINKCODE, filename)
        else:
            url = "{}/{}?oinkcode={}".format(base_url, filename, OINKCODE)
            md5url = "{}/{}.md5?oinkcode={}".format(base_url, filename, OINKCODE)

        print("[+] Using URL: {}".format(url))

        filename = filename.replace("/", "_")
        outfile = os.path.join(tmpdir, filename)

        try:
            md5 = get_file(md5url).strip()
        except urllib.error.HTTPError:
            print("[-] Error downloading {}".format(filename))
            continue
        if not is_new_release(filename, md5):
            print("[-] {} is not a new release, skipping".format(filename))
            continue

        print("[+] MD5 mismatch, assuming new release and downloading")

        get_file(url, outfile)

        if verify(outfile, md5):
            print("[+] Successfully downloaded, releasing {}".format(filename))
            release(outfile, filename, md5)
        else:
            print("[+] Failed to download {}, MD5 mismatch".format(filename))
finally:
    print("[+] Removing temp directory")
    shutil.rmtree(tmpdir)
