Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaLUH6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 02:58:31 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@vger.kernel.org" <linux-firmware@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: firmware update for iwlwifi (3160 / 7260 / 7265)
Date: Sun, 21 Dec 2014 07:58:27 +0000
Message-ID: <1419148696.2316.7.camel@egrumbacBox> (sfid-20141221_085911_575957_FB9D5FD4)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-LAjZsY1lBNKmxnwlqY2b"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-LAjZsY1lBNKmxnwlqY2b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux firmware maintainers,

Here is new release of the -10.ucode firmware for the following Intel
Wireless devices:
3160 / 7260 / 7265 / 7265D

This release includes bug fixes only. We fix here firmware assertions
and association with buggy APs.

Please pull - thanks.


The following changes since commit
38e5405c96d10bb42b629b45210c46166461fc21:

  cxgb4: Update firmware to revision 1.12.25.0 (2014-12-01 15:48:02
-0500)

are available in the git repository at:


git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
master

for you to fetch changes up to 571ad1ab9f6c85ba859387166f528a70ee1aa151:

  iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D (2014-12-21
09:52:07 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D

 WHENCE                 |   8 ++++----
 iwlwifi-3160-10.ucode  | Bin 610168 -> 610064 bytes
 iwlwifi-7260-10.ucode  | Bin 672480 -> 672372 bytes
 iwlwifi-7265-10.ucode  | Bin 736968 -> 736864 bytes
 iwlwifi-7265D-10.ucode | Bin 740636 -> 740456 bytes
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/WHENCE b/WHENCE
index 44c41c7..df2dffa 100644
--- a/WHENCE
+++ b/WHENCE
@@ -816,7 +816,7 @@ File: iwlwifi-7260-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7260-10.ucode
-Version: 23.10.10.0
+Version: 23.11.10.0
=20
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -828,7 +828,7 @@ File: iwlwifi-3160-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-3160-10.ucode
-Version: 23.10.10.0
+Version: 23.11.10.0
=20
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
@@ -837,10 +837,10 @@ File: iwlwifi-7265-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7265-10.ucode
-Version: 23.10.10.0
+Version: 23.11.10.0
=20
 File: iwlwifi-7265D-10.ucode
-Version: 23.10.10.0
+Version: 23.11.10.0
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
index 8cec7bf..241bd4e 100644
Binary files a/iwlwifi-3160-10.ucode and b/iwlwifi-3160-10.ucode differ
diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
index 9e5b930..c7d8532 100644
Binary files a/iwlwifi-7260-10.ucode and b/iwlwifi-7260-10.ucode differ
diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
index 488ddd0..bda8dff 100644
Binary files a/iwlwifi-7265-10.ucode and b/iwlwifi-7265-10.ucode differ
diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
index 01194db..ebda04c 100644
Binary files a/iwlwifi-7265D-10.ucode and b/iwlwifi-7265D-10.ucode
differ


--=-LAjZsY1lBNKmxnwlqY2b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJUln2YAAoJEC0Llv5uNjIBR6UP/j1n4C77zzmqsbKWa4+3kKcZ
72dWj90vk9Bv2fxqAgC53CIcGXZySgVN2zmITUHIEy/K1yQKfTq1/Ft1niHqIvom
SGfxzv7t1pnXAoEIqcUpMID9OcD9vZoBq3s/LNGWTA+1tswJVfHDhqfLbGwWhzWJ
GjrqciupNZLjzTe9jQp8PwpTm70EHNftAoHTS7wtApiofqwI+Cqcc+UqHJRVIh+n
B4ZTEgkiIbM2yeGpFKLnHyLCtB7itMwdxrGh74Z/Hhp06kj9sT5oBamkfxvBPy9u
bW2reAetuqRh1vBndfFHpiRIQR7Em0KboZ7I2Kui94X4DlOKufDS9b09vCfNZ+5i
5wMMwwGiSILhwD0w6xkMY6/iAwgqKDQGdSAbz0U9MzQI5x95EuxGYy8zN9kvdlH8
bKMNcHHrISIbOOTlGwIoMexoTjP619lWnxY6XvCuaq9zO4ynNGwVob8E9xq8OaqO
IPRZehdYiUQBa/+gDBVdDFgbD3QrUMaXLWHPSW05pKUay40CteBf9TzxStiTbz9/
jk5yfIFltnYN/DwIXJ+rXdHqVb3TxT2LRqxOCWxThJ+3az1jvoLWOyOST8OvbJvF
Z4QSe3qGk54Xq3pQ2Uh4XpxTtUGT8SNd46Ns67v8oOihjEhILH2bhqsmmxw11zcE
BIDw9Ggg49V0tjwSzOMX
=gl5n
-----END PGP SIGNATURE-----

--=-LAjZsY1lBNKmxnwlqY2b--
