Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54238 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaJUSIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 14:08:42 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so1721185wib.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 11:08:39 -0700 (PDT)
Message-ID: <5446A11C.7010602@gmail.com> (sfid-20141021_200847_115653_36795DD8)
Date: Tue, 21 Oct 2014 21:08:28 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linux-firmware@kernel.org
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: new firmware for 7260 / 7265 / 3160 - 25.228.9.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="dQgxowSDHjpoEJWIREFhqaC350E3CV6Jc"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dQgxowSDHjpoEJWIREFhqaC350E3CV6Jc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dear linux-firmware.git maintainers,

Intel released a new -9 firmware for its WiFi adpaters for the 7000 famil=
y.
No new features here, but only bug fixes.

The following changes since commit 0e5f63771d0df6d7859f7c4100a74d737c62ac=
88:

  linux-firmware: Add firmware patch for Intel Bluetooth 7265 ROM-spin(D0=
) (2014-10-09 11:59:44 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.=
git master

for you to fetch changes up to 1f9f9df353b11c9ea0130dfe68053aaaee376df3:

  iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-10-21 21:07:26 +0=
300)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update firmware for 3160 / 7260 / 7265

 WHENCE               |   6 +++---
 iwlwifi-3160-9.ucode | Bin 669156 -> 669792 bytes
 iwlwifi-7260-9.ucode | Bin 681464 -> 680432 bytes
 iwlwifi-7265-9.ucode | Bin 697012 -> 697704 bytes
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/WHENCE b/WHENCE
index b77516d..5c95940 100644
--- a/WHENCE
+++ b/WHENCE
@@ -813,7 +813,7 @@ File: iwlwifi-7260-8.ucode
 Version: 22.24.8.0
=20
 File: iwlwifi-7260-9.ucode
-Version: 25.222.9.0
+Version: 25.228.9.0
=20
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -822,13 +822,13 @@ File: iwlwifi-3160-8.ucode
 Version: 22.24.8.0
=20
 File: iwlwifi-3160-9.ucode
-Version: 25.222.9.0
+Version: 25.228.9.0
=20
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
=20
 File: iwlwifi-7265-9.ucode
-Version: 25.222.9.0
+Version: 25.228.9.0
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
diff --git a/iwlwifi-3160-9.ucode b/iwlwifi-3160-9.ucode
index 638c7fa..aa5aac3 100644
Binary files a/iwlwifi-3160-9.ucode and b/iwlwifi-3160-9.ucode differ
diff --git a/iwlwifi-7260-9.ucode b/iwlwifi-7260-9.ucode
index 3175322..e6de383 100644
Binary files a/iwlwifi-7260-9.ucode and b/iwlwifi-7260-9.ucode differ
diff --git a/iwlwifi-7265-9.ucode b/iwlwifi-7265-9.ucode
index 1767a33..f42fb38 100644
Binary files a/iwlwifi-7265-9.ucode and b/iwlwifi-7265-9.ucode differ



--dQgxowSDHjpoEJWIREFhqaC350E3CV6Jc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJURqEjAAoJEC0Llv5uNjIB/sgP/ipBlnZa8ui6cHXYSsUMNoXG
elQyXrX+e2EGD5sKlTuOt5DS1kTqOFyhYMb0w1bvTIISg0v/1hX+sd3InpZ8awwB
ffcooPOvxtSlcZFiqeoZ/Uas+MYsPl703seTkZL4Pbod4ZorwgKRESsgey++QI8B
jD6iEjkCGxjD4geg7+hMaexApAQQ5Hum3SS6PzSnYahluZQ9aLYdHJw6qVpx+d68
lYEnZO18HZ4M+eh+K//k8V5LgOIYNJbn+rMqUctqMyvFV+Ga0KtiTs6aWMKO/Sc9
C6vYqeWA+bDB/SKS7g/B2lywhUdMGoZNn+kk9uFZFy6XhL5C3nNAvRLujeib07L2
ul1mrPaUD3ReBORCXafLBaSlRP5uSxgg1Kdqr2VYoPkxzNjBr+RvyoAPE2Ga8j7j
1Cr/4+4YZGIDZWKREJ1HcqPd4RxbFrNCaE8nR66GHHkfB+wjRTI0egxj6E9RU036
l/bRTojDsP35WWRG0ybT0H37ip0QK0zBMvMEbdOfxW3bvo+drrKjp1bSZ4ityCiT
kfq7L3k6RiIrAruLLSnVOgoFYq517IQoxemt674IajeexPWuTRdNK92pBeza6/9M
vIjGqIG6FVLnXJc/kkvCEgBTFTp+pNwdLa3FIW7Y4IFMvAgsw54lyolq1AMhmMNV
jiLQaiGODxm45Sq68CtP
=vqNR
-----END PGP SIGNATURE-----

--dQgxowSDHjpoEJWIREFhqaC350E3CV6Jc--
