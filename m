Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:35685 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaIBIPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 04:15:35 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so6533017wes.39
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 01:15:33 -0700 (PDT)
Message-ID: <54057C59.4020807@gmail.com> (sfid-20140902_101730_536789_7A59C3C1)
Date: Tue, 02 Sep 2014 11:14:17 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linux-firmware@kernel.org
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: new firmware for 7260 / 7265 / 3160: 25.222.9.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CC0nRJHtDO2iNViNEc3amQlswOvVW98GQ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CC0nRJHtDO2iNViNEc3amQlswOvVW98GQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dear linux-firmware.git maintainers,

Intel released a new -9 firmware for its WiFi adpaters for the 7000 famil=
y.
No new features here, but only bug fixes.

The following changes since commit e2844339cb779c00f856c554958e16beca99b4=
62:

  iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-05-19 14:45:28 +0=
300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.=
git master

for you to fetch changes up to e302d06fb8cd3ceade38ce484636094b1cd25a23:

  iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-09-02 11:06:42 +0=
300)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update firmware for 3160 / 7260 / 7265

 WHENCE               |   6 +++---
 iwlwifi-3160-9.ucode | Bin 666792 -> 669156 bytes
 iwlwifi-7260-9.ucode | Bin 679380 -> 681464 bytes
 iwlwifi-7265-9.ucode | Bin 691960 -> 697012 bytes
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/WHENCE b/WHENCE
index e174b52..e9f5df8 100644
--- a/WHENCE
+++ b/WHENCE
@@ -813,7 +813,7 @@ File: iwlwifi-7260-8.ucode
 Version: 22.24.8.0

 File: iwlwifi-7260-9.ucode
-Version: 23.214.9.0
+Version: 25.222.9.0

 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -822,13 +822,13 @@ File: iwlwifi-3160-8.ucode
 Version: 22.24.8.0

 File: iwlwifi-3160-9.ucode
-Version: 23.214.9.0
+Version: 25.222.9.0

 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0

 File: iwlwifi-7265-9.ucode
-Version: 23.214.9.0
+Version: 25.222.9.0

 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details

diff --git a/iwlwifi-3160-9.ucode b/iwlwifi-3160-9.ucode
index 7b18779..638c7fa 100644
Binary files a/iwlwifi-3160-9.ucode and b/iwlwifi-3160-9.ucode differ
diff --git a/iwlwifi-7260-9.ucode b/iwlwifi-7260-9.ucode
index 0239740..3175322 100644
Binary files a/iwlwifi-7260-9.ucode and b/iwlwifi-7260-9.ucode differ
diff --git a/iwlwifi-7265-9.ucode b/iwlwifi-7265-9.ucode
index 0a3f674..1767a33 100644
Binary files a/iwlwifi-7265-9.ucode and b/iwlwifi-7265-9.ucode differ


--CC0nRJHtDO2iNViNEc3amQlswOvVW98GQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBXyGAAoJEC0Llv5uNjIBw1EP/2r5dCIab2z5hG2dzA0A2YUB
z+wRTEkGPt8HlOJieaWJIsrgycXmFb1UJ4tSWAPf0cZr0WwwPStgPNupheEWaqAq
1VD7SiES9NmaDs74P+2agH5drDvY8qHk2P4SzS5GKZzR6ns//ZKG8hFUHOHc9aR6
wT637Hq8UsdtTLpLdTER/l5LY2Ri0a/4Fvwuw3S/e+MA701PzQ5+x2SCQRKrubCy
0UtTiRXN/45KDY+ABMVZE80VvU4fBXJyCroYgh9DecS/mwP8EcLszNFGCGrwokzZ
V/GZc8ifIPoOjCpjSZ7xYC45eAg4Ausa2yWvbIYUUvSwqWd9ybbwJnfKJ653ztiw
i8Zu7Vt6k2+pg/DQCk/x/ifM+yVCunMQmSjKf6phV9k7Cy453O81Z6piZvQ06vnK
iV5I3pj5BN0u/oZr2//JNIEkWNtXHOzNlou7x/8e6MY8Zn4ThqAFHKWl31H99ZDd
rw3v/d+Ou512S00yOoqqeK4R2A2227JHIxkiqUqfJ7GNxvkuNEnkM7OrV63iDu4M
zE+YtdIRv2gQkvSpmJ70IKORLsVxQd4m4jReAX03xYym9VjS0rhXg3n04CubnTGs
KLRRicoDeuCfQvriphmuH9sPTHjMepPr8pF4cYXdq6v/AbYO6fe4ExCXFpR1ATuw
ASm/kBB+jDmsMpBhYZGK
=M3+z
-----END PGP SIGNATURE-----

--CC0nRJHtDO2iNViNEc3amQlswOvVW98GQ--
