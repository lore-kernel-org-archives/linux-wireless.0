Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56081 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaD2Nhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 09:37:31 -0400
Received: by mail-wi0-f178.google.com with SMTP id bs8so441701wib.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2014 06:37:30 -0700 (PDT)
Message-ID: <535FA906.6060905@gmail.com> (sfid-20140429_153735_220496_86115DA0)
Date: Tue, 29 Apr 2014 16:28:38 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: ben@decadent.org.uk
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: new firmware for Intel 7260 / 3160 / 7265 - 22.212.9.0
References: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com>
In-Reply-To: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jkL3QSJtqPI4nqhXRNsSR5lnh01e3gOPk"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jkL3QSJtqPI4nqhXRNsSR5lnh01e3gOPk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ben,

You haven't pulled my tree yet, but I can't hold this any longer, so here=
 you go. This pull request includes the previous one obviously.
I have here a new firmware for a new device: 7265, and an upgrade of the =
firmware for 7260 / 3160 / 7265 supported in 3.14.

Thanks!

The following changes since commit dec41bce44e0dff6a2c3358a958fadf22bf588=
58:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/=
egrumbach/linux-firmware (2014-03-16 18:12:54 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.=
git master

for you to fetch changes up to 7a67dbf9c087ef64b3d3fc9ce448c2efdb2e365f:

  iwlwifi: add new firmware for 3160 / 7260 / 7265 (2014-04-29 13:05:28 +=
0300)

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: add firmware for 7265
      iwlwifi: add new firmware for 3160 / 7260 / 7265

 LICENCE.iwlwifi_firmware |   2 +-
 WHENCE                   |  14 +++++++++++++-
 iwlwifi-3160-9.ucode     | Bin 0 -> 666256 bytes
 iwlwifi-7260-9.ucode     | Bin 0 -> 678904 bytes
 iwlwifi-7265-8.ucode     | Bin 0 -> 690452 bytes
 iwlwifi-7265-9.ucode     | Bin 0 -> 691320 bytes
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
index ca0f30b..2b6cc75 100644
--- a/WHENCE
+++ b/WHENCE
@@ -812,15 +812,27 @@ Version: 22.1.7.0
 File: iwlwifi-7260-8.ucode
 Version: 22.24.8.0

+File: iwlwifi-7260-9.ucode
+Version: 22.212.9.0
+
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0

 File: iwlwifi-3160-8.ucode
 Version: 22.24.8.0

+File: iwlwifi-3160-9.ucode
+Version: 22.212.9.0
+
+File: iwlwifi-7265-8.ucode
+Version: 22.24.8.0
+
+File: iwlwifi-7265-9.ucode
+Version: 22.212.9.0
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
index 0000000..243fe52
Binary files /dev/null and b/iwlwifi-3160-9.ucode differ
diff --git a/iwlwifi-7260-9.ucode b/iwlwifi-7260-9.ucode
new file mode 100644
index 0000000..bc71b06
Binary files /dev/null and b/iwlwifi-7260-9.ucode differ
diff --git a/iwlwifi-7265-8.ucode b/iwlwifi-7265-8.ucode
new file mode 100644
index 0000000..3b69247
Binary files /dev/null and b/iwlwifi-7265-8.ucode differ
diff --git a/iwlwifi-7265-9.ucode b/iwlwifi-7265-9.ucode
new file mode 100644
index 0000000..baa8473
Binary files /dev/null and b/iwlwifi-7265-9.ucode differ


--jkL3QSJtqPI4nqhXRNsSR5lnh01e3gOPk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTX6q+AAoJEC0Llv5uNjIBLg0QAJoXDIGCSzfp6zGm9u69SYNS
EEhTxd/kAWoMmxlRLus9IjZoo7VTyjEJeZrWy7hb7Y0pKpCu5zdfnQU0nfmoIpM4
882qSmXsZGcnwVLB+5/vC1BG9PCCqHjwDMWKfhiZtfco8vvlVfCHxDGMsKEU/INR
N61fX4cuXJ3bQGD2+fBHrdENsMOJvoRNJYQZ4lP/2kGP3gpw4ueYWA9xUJJauZBq
kRN7lAOADnbhbUie/7LETBbqx8TTIBfNJzAZ4Xvbvqi3P0+KJPraqorb7wubCSRY
hfQ97W64xVBJpCMbLfI2tu6HInCZE41JW1CF+nTERH5r9be8KqW5h2GNLY/qTmGF
6XCDcCcwTV50IxBFN9jjEaNrUosjiOW8RYaeZt9EFEfrG4vDUTgDh2aPW/xEoFY3
tu6pcjA+2VEWYNt/kHSuCvRmwEtoHn1yd9DaWOdtopmQ87ypLQFMbUcwIVVHMbCo
A9yXlvNbfhVekMpAin03OGO189sRdfcJh0ePs4awCXQvj1Z3PKdg64/AQ2qoyrtH
kmKq/Kl+DuQY95KvOXe6BP1Vge0uA4oBnsfZE1SWy0wErdGKERK6rmaadwQBXOzq
6LxXEaqV7LFpa+Q4YmzsGd1kN5+J+//lHZQZu1GIz0hf5rrrn5MCQKcW7yOL5w6l
U5QupZA1HpVURWiqm2kE
=6oaE
-----END PGP SIGNATURE-----

--jkL3QSJtqPI4nqhXRNsSR5lnh01e3gOPk--
