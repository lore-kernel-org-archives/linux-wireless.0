Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54898 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaKWUKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 15:10:07 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so3869288wiw.9
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2014 12:10:06 -0800 (PST)
Message-ID: <54723F1B.4030509@gmail.com> (sfid-20141123_211012_454350_97D55AF0)
Date: Sun, 23 Nov 2014 22:10:03 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linux-firmware@kernel.org
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: firmware updates for Intel Wireless devices 3160/7260/7265
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fU8meD5NHJ3RFU0vGBnSep2T0slws89n5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fU8meD5NHJ3RFU0vGBnSep2T0slws89n5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

Intel officially released a new spin of the -9 version of the firmware fo=
r devices 3160, 7260 and 7265.
This release had been announced a while ago, but the linux-firmware.git's=
 maintainers didn't pick it up.
This is a new pull request with almost the exact same -9 version - it has=
 one more bug fix.
Version: 25.228.9.0.

We also release new version (-10) of the firmware for the same devices. T=
his firmware includes new features
such as TDLS, Channel switch and others.
Version: 23.10.10.0.

Please pull...

The following changes since commit 0e5f63771d0df6d7859f7c4100a74d737c62ac=
88:

  linux-firmware: Add firmware patch for Intel Bluetooth 7265 ROM-spin(D0=
) (2014-10-09 11:59:44 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.=
git master

for you to fetch changes up to 064309720ed861dde985c39cdc1a34e7bcf93cc9:

  iwlwifi: add new firmware for 3160 / 7260 / 7265 / 7265D (2014-11-21 11=
:11:06 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: update firmware for 3160 / 7260 / 7265
      iwlwifi: add new firmware for 3160 / 7260 / 7265 / 7265D

 WHENCE                 |  18 +++++++++++++++---
 iwlwifi-3160-10.ucode  | Bin 0 -> 610168 bytes
 iwlwifi-3160-9.ucode   | Bin 669156 -> 669872 bytes
 iwlwifi-7260-10.ucode  | Bin 0 -> 672480 bytes
 iwlwifi-7260-9.ucode   | Bin 681464 -> 680508 bytes
 iwlwifi-7265-10.ucode  | Bin 0 -> 736968 bytes
 iwlwifi-7265-9.ucode   | Bin 697012 -> 697828 bytes
 iwlwifi-7265D-10.ucode | Bin 0 -> 740636 bytes
 8 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 iwlwifi-3160-10.ucode
 create mode 100644 iwlwifi-7260-10.ucode
 create mode 100644 iwlwifi-7265-10.ucode
 create mode 100644 iwlwifi-7265D-10.ucode

diff --git a/WHENCE b/WHENCE
index b77516d..a4bf645 100644
--- a/WHENCE
+++ b/WHENCE
@@ -813,7 +813,10 @@ File: iwlwifi-7260-8.ucode
 Version: 22.24.8.0
=20
 File: iwlwifi-7260-9.ucode
-Version: 25.222.9.0
+Version: 25.228.9.0
+
+File: iwlwifi-7260-10.ucode
+Version: 23.10.10.0
=20
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -822,13 +825,22 @@ File: iwlwifi-3160-8.ucode
 Version: 22.24.8.0
=20
 File: iwlwifi-3160-9.ucode
-Version: 25.222.9.0
+Version: 25.228.9.0
+
+File: iwlwifi-3160-10.ucode
+Version: 23.10.10.0
=20
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
=20
 File: iwlwifi-7265-9.ucode
-Version: 25.222.9.0
+Version: 25.228.9.0
+
+File: iwlwifi-7265-10.ucode
+Version: 23.10.10.0
+
+File: iwlwifi-7265D-10.ucode
+Version: 23.10.10.0
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
new file mode 100644
index 0000000..8cec7bf
Binary files /dev/null and b/iwlwifi-3160-10.ucode differ
diff --git a/iwlwifi-3160-9.ucode b/iwlwifi-3160-9.ucode
index 638c7fa..287a3a5 100644
Binary files a/iwlwifi-3160-9.ucode and b/iwlwifi-3160-9.ucode differ
diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
new file mode 100644
index 0000000..9e5b930
Binary files /dev/null and b/iwlwifi-7260-10.ucode differ
diff --git a/iwlwifi-7260-9.ucode b/iwlwifi-7260-9.ucode
index 3175322..b271e86 100644
Binary files a/iwlwifi-7260-9.ucode and b/iwlwifi-7260-9.ucode differ
diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
new file mode 100644
index 0000000..488ddd0
Binary files /dev/null and b/iwlwifi-7265-10.ucode differ
diff --git a/iwlwifi-7265-9.ucode b/iwlwifi-7265-9.ucode
index 1767a33..bbca2fe 100644
Binary files a/iwlwifi-7265-9.ucode and b/iwlwifi-7265-9.ucode differ
diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
new file mode 100644
index 0000000..01194db
Binary files /dev/null and b/iwlwifi-7265D-10.ucode differ


--fU8meD5NHJ3RFU0vGBnSep2T0slws89n5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcj8cAAoJEC0Llv5uNjIBOCoP/3lkBmlUDquRto2QNFNTbxfd
TZ5J2bi/7Qgv0jankKBpQDY7s53B8LhksLeo6j0UNGsxqYDo0DFZ9XZxzx70/skK
k++IB/SOwWMAH6Ugfu7FmdXq6Or8OFxps/ItM5abdR4ZGt1gT4LnYPXdyhgMFyh/
JC3CqgE8mcaO3v1dpve5acd3f18dbOjBkrthWvki9jhMR6rfN2HffJ1n0EysM+bo
glM7iMVcyHN0B9duB9rIndy+ibOcFmBCn30McpgVKG/ZuUwTGFwt9ZfPtXW3wEDq
3gkVcJUoQfgoS3XNNMRr9V+rZUXvX0JZNjco9LxVaMXjQpU2qPMh2mfPchGVaOVM
m/yUwsSqyUbP0XsyQBo5dz1lEclMRWnWyeNudr9IsqHlYt+HwsOWwDy+XxTytNAj
jPg/Z3OTGaG+lwL++aSpeWD15aqQuSENhsM/PqWzokJlPdCErx2ofBGqRWbdDW2h
l2Sj7NjFXTZda6JQM2Jq/1CsN4VyRn+n/G9mE+AhUHQbmk3p7PcoukKXK/3Fw4Qg
sFYmDSonfdN9g0IenMlGyE3DYjJ8jUJWfq1JwsKts78byyChcQcStWkbQgZuZ5yi
pScVCm4/eRSTOtF7KjZyc9wHRTDmXOerJJ+2SBJeuErD6mnO1piLVdCsZppf+wR1
RpPqIgPbu7yx91tDKp0H
=jlVX
-----END PGP SIGNATURE-----

--fU8meD5NHJ3RFU0vGBnSep2T0slws89n5--
