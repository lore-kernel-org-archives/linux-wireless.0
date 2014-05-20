Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64757 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETKIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 06:08:10 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so632906wib.7
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 03:08:08 -0700 (PDT)
Message-ID: <537B295E.7080307@gmail.com> (sfid-20140520_120814_546881_2FCA17FA)
Date: Tue, 20 May 2014 13:07:26 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: ben@decadent.org.uk, dwmw2@infradead.org
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: firmware for iwlwifi 7260 / 7265 / 3160
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="EU7meEUcn03xPR26pSl2fp9mdGeBvr2ll"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EU7meEUcn03xPR26pSl2fp9mdGeBvr2ll
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I am sending (yet) another pull request to update the firmware for iwlwif=
i 7260 / 7265 / 3160 devices,
Since a few users have been using the new firmware even if it hasn't hit =
linux-firmware.git, I didn't amend my commit, but rather added a new comm=
it.

So we have here a firmware for 7265 (this device has no firmware in linux=
-firmware.git yet) and updates for the three aforementioned devices.

Please pull (please).


The following changes since commit dec41bce44e0dff6a2c3358a958fadf22bf588=
58:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/=
egrumbach/linux-firmware (2014-03-16 18:12:54 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.=
git master

for you to fetch changes up to e2844339cb779c00f856c554958e16beca99b462:

  iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-05-19 14:45:28 +0=
300)

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: add firmware for 7265
      iwlwifi: add new firmware for 3160 / 7260 / 7265
      iwlwifi: update firmware for 3160 / 7260 / 7265

 LICENCE.iwlwifi_firmware |   2 +-
 WHENCE                   |  14 +++++++++++++-
 iwlwifi-3160-9.ucode     | Bin 0 -> 666792 bytes
 iwlwifi-7260-9.ucode     | Bin 0 -> 679380 bytes
 iwlwifi-7265-8.ucode     | Bin 0 -> 690452 bytes
 iwlwifi-7265-9.ucode     | Bin 0 -> 691960 bytes
 6 files changed, 14 insertions(+), 2 deletions(-)
 create mode 100644 iwlwifi-3160-9.ucode
 create mode 100644 iwlwifi-7260-9.ucode
 create mode 100644 iwlwifi-7265-8.ucode
 create mode 100644 iwlwifi-7265-9.ucode

diff --git a/LICENCE.iwlwifi_firmware b/LICENCE.iwlwifi_firmware
index 01c32a0..b168a60 100644
--- a/LICENCE.iwlwifi_firmware
+++ b/LICENCE.iwlwifi_firmware
@@ -1,4 +1,4 @@
-Copyright (c) 2006-2013, Intel Corporation.
+Copyright (c) 2006-2014, Intel Corporation.
 All rights reserved.

 Redistribution.  Redistribution and use in binary form, without
diff --git a/WHENCE b/WHENCE
index ca0f30b..e174b52 100644
--- a/WHENCE
+++ b/WHENCE
@@ -812,15 +812,27 @@ Version: 22.1.7.0
 File: iwlwifi-7260-8.ucode
 Version: 22.24.8.0

+File: iwlwifi-7260-9.ucode
+Version: 23.214.9.0
+
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0

 File: iwlwifi-3160-8.ucode
 Version: 22.24.8.0

+File: iwlwifi-3160-9.ucode
+Version: 23.214.9.0
+
+File: iwlwifi-7265-8.ucode
+Version: 22.24.8.0
+
+File: iwlwifi-7265-9.ucode
+Version: 23.214.9.0
+
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details

-Also available from http://wireless.kernel.org/en/users/Drivers/iwlwifi/=
?n=3DDownloads
+Also available from http://wireless.kernel.org/en/users/Drivers/iwlwifi#=
Firmware

 ------------------------------------------------------------------------=
--

diff --git a/iwlwifi-3160-9.ucode b/iwlwifi-3160-9.ucode
new file mode 100644
index 0000000..7b18779
Binary files /dev/null and b/iwlwifi-3160-9.ucode differ
diff --git a/iwlwifi-7260-9.ucode b/iwlwifi-7260-9.ucode
new file mode 100644
index 0000000..0239740
Binary files /dev/null and b/iwlwifi-7260-9.ucode differ
diff --git a/iwlwifi-7265-8.ucode b/iwlwifi-7265-8.ucode
new file mode 100644
index 0000000..3b69247
Binary files /dev/null and b/iwlwifi-7265-8.ucode differ
diff --git a/iwlwifi-7265-9.ucode b/iwlwifi-7265-9.ucode
new file mode 100644
index 0000000..0a3f674
Binary files /dev/null and b/iwlwifi-7265-9.ucode differ


--EU7meEUcn03xPR26pSl2fp9mdGeBvr2ll
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTeyl0AAoJEC0Llv5uNjIBs6cP/00CmnMjrsWK2h8P2pkCA1XI
gBaAjEDUCzvzU6CAw+aEBIFOcA2mPpNxvlkCIGJcA0na+Yu59+7jKhde94HPK0+S
azG7EEBMShg1wYh4U5e5OoCz6/K6nzRGQTQ5QkEtFlJL8VlyPwqbkSuxOQbD9fDY
kLLUBe1cY6PAybH9Hi+maO/JvEN6+SgQUcphh47UR1rCklXgK5wMdulYbL1JKzW9
5psysqt+wc0X/M218smiqB4HxWyMB0Ehf4y8Z2a3sAtcS2e2rNihhbnnEP1Z4ya5
lluqpfZOGmtW/4NHCpQblgPJSv2DLqvSl0Z13pQM8i0Grdv7OJOUb0QW+oKjZldS
ORRqgjkA11CVoaLTotVDRhbmkhkZ0lQ1+HpOxX7D7VlXetpZbhLjW55N3ySnM7NZ
Mxtyt5fIN7oiLwudT2hNo3sXbFoPyEZ2wwcO/irlbntg4/cT9EcW40vDlvLUiM5G
wwkV4vKeAWw0R77OLYvn3k/F4D11XEdCpDBQLWbwd/d8iONv3vGqBocFI/6PFF+j
rsJmZNDxjTm+9EPHWE3uNL0vsf+ZvUZ2Y4I0fITbQ96O2r+cFNWjlxbLsWZtPnWc
mIrEXC5j83kqr6UOOenSpaNmm14mv23rTceXQWb+EMDnqwrSPualKRtxQdBM7wNt
swDugWeroEHuZBrbkikb
=DOEb
-----END PGP SIGNATURE-----

--EU7meEUcn03xPR26pSl2fp9mdGeBvr2ll--
