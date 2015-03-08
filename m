Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56177 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbbCHN6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 09:58:12 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: new firmware for Intel wireless Intel 3160 / 7260 /
 7265 / 7265D devices
Date: Sun, 8 Mar 2015 13:58:08 +0000
Message-ID: <1425823087.14627.1.camel@egrumbacBox> (sfid-20150308_145816_292316_675EBA29)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-FdCmjmvu5WwqA4iQO4nk"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-FdCmjmvu5WwqA4iQO4nk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

This is a pull request for new firmwares for the Intel wireless devices
mentioned in the subject.

I replace -10.ucode with new ones (that includes bug fixes).

Please pull.


The following changes since commit 1e67c28c65137dd1647e597ebef45d8a0c9168f9=
:

  ath9k_htc: update versions in WHENCE (2015-03-06 11:35:57 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
master

for you to fetch changes up to d81bc142d7068073699ce6ffbfbdf268baa9f200:

  iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D (2015-03-08 15:5=
5:20 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D

 WHENCE                 |   8 ++++----
 iwlwifi-3160-10.ucode  | Bin 610008 -> 609892 bytes
 iwlwifi-7260-10.ucode  | Bin 672368 -> 672352 bytes
 iwlwifi-7265-10.ucode  | Bin 736860 -> 736844 bytes
 iwlwifi-7265D-10.ucode | Bin 740452 -> 740436 bytes
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/WHENCE b/WHENCE
index d07ddba..9230517 100644
--- a/WHENCE
+++ b/WHENCE
@@ -825,7 +825,7 @@ File: iwlwifi-7260-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7260-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-7260-12.ucode
 Version: 25.15.12.0
@@ -840,7 +840,7 @@ File: iwlwifi-3160-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-3160-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-3160-12.ucode
 Version: 25.15.12.0
@@ -852,13 +852,13 @@ File: iwlwifi-7265-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7265-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-7265-12.ucode
 Version: 25.15.12.0
=20
 File: iwlwifi-7265D-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-7265D-12.ucode
 Version: 25.15.12.0
diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
index 8029b17..843d4d4 100644
Binary files a/iwlwifi-3160-10.ucode and b/iwlwifi-3160-10.ucode differ
diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
index 917378a..1a828d7 100644
Binary files a/iwlwifi-7260-10.ucode and b/iwlwifi-7260-10.ucode differ
diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
index d1b0504..a58d323 100644
Binary files a/iwlwifi-7265-10.ucode and b/iwlwifi-7265-10.ucode differ
diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
index 79dcb31..2f6ce2c 100644
Binary files a/iwlwifi-7265D-10.ucode and b/iwlwifi-7265D-10.ucode differ
The following changes since commit 1e67c28c65137dd1647e597ebef45d8a0c9168f9=
:

  ath9k_htc: update versions in WHENCE (2015-03-06 11:35:57 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
master

for you to fetch changes up to d81bc142d7068073699ce6ffbfbdf268baa9f200:

  iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D (2015-03-08 15:5=
5:20 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D

 WHENCE                 |   8 ++++----
 iwlwifi-3160-10.ucode  | Bin 610008 -> 609892 bytes
 iwlwifi-7260-10.ucode  | Bin 672368 -> 672352 bytes
 iwlwifi-7265-10.ucode  | Bin 736860 -> 736844 bytes
 iwlwifi-7265D-10.ucode | Bin 740452 -> 740436 bytes
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/WHENCE b/WHENCE
index d07ddba..9230517 100644
--- a/WHENCE
+++ b/WHENCE
@@ -825,7 +825,7 @@ File: iwlwifi-7260-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7260-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-7260-12.ucode
 Version: 25.15.12.0
@@ -840,7 +840,7 @@ File: iwlwifi-3160-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-3160-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-3160-12.ucode
 Version: 25.15.12.0
@@ -852,13 +852,13 @@ File: iwlwifi-7265-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7265-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-7265-12.ucode
 Version: 25.15.12.0
=20
 File: iwlwifi-7265D-10.ucode
-Version: 23.14.10.0
+Version: 23.15.10.0
=20
 File: iwlwifi-7265D-12.ucode
 Version: 25.15.12.0
diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
index 8029b17..843d4d4 100644
Binary files a/iwlwifi-3160-10.ucode and b/iwlwifi-3160-10.ucode differ
diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
index 917378a..1a828d7 100644
Binary files a/iwlwifi-7260-10.ucode and b/iwlwifi-7260-10.ucode differ
diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
index d1b0504..a58d323 100644
Binary files a/iwlwifi-7265-10.ucode and b/iwlwifi-7265-10.ucode differ
diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
index 79dcb31..2f6ce2c 100644
Binary files a/iwlwifi-7265D-10.ucode and b/iwlwifi-7265D-10.ucode differ


--=-FdCmjmvu5WwqA4iQO4nk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJU/FVvAAoJEC0Llv5uNjIB9wMP/AjhKreB0/H5RdbOJRYZO0x5
qMAAUbo7bARFWxX/vncAs6uGw0+LYG7Bwh52UALUqmvX0JuOEJnolW44sx5Wf99S
LQmULEUUgso13sWgB+QMo9aCQcN9fjyHxBO5j63ja6tejrsF3MqOlnfMuE9a0/XE
F/kP8XtbsnMws4xV79OewF/mwV7aPW/G8hdWwCLLMpQuPp/CEcAUxlypK1BgBRg5
I9C0GvddFW6YHxeH0fFLw1CKPD97OTPY5s0dyrhcg7jIKnuhHc0YxF7UmFlT1pnN
vDWd1agTvuzZ2/v7AXV5pU9QkV/dQZDpI0r+Xp22HFI4lkpli+97gv/ggVDHD5P6
iBwyHWAPODUtIiJ3QHNsg1sglC7yyj5Ldmgx+z0TC/une2jc6AE/l/kqqE0941xK
qoFpwzBSIoPx7/iUDkTBUwj2dVFoXZZX9JyUcdwceY7KV8CY4f4YX8XhkNHRdMUd
vtd7jbEDfAmCepZ4RlGoilk0+8gHCDpfn0TQyqvOxk3DSSYNJ7qv3D4tIpVHs/Wi
GnY6cfrjcZLA2ZVddPfABoud++rIHJuXqOwTslu77Qu0bZzsvJV19gh5ky5v5q5A
goU+LAk4JTaaiZa87z6d+wsG8Soll0C3YqPhoLk2YZaUZNE/MYcgunDw7IQ7u1Dd
ytoM2RT7y6QCFmwqfWEG
=VWc1
-----END PGP SIGNATURE-----

--=-FdCmjmvu5WwqA4iQO4nk--
