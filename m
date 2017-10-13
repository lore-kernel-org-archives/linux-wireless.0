Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53100 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751619AbdJMLuj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 07:50:39 -0400
Message-ID: <1507895435.5497.18.camel@coelho.fi> (sfid-20171013_135043_213166_0761358E)
From: Luca Coelho <luca@coelho.fi>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Fri, 13 Oct 2017 14:50:35 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-nVxzS99lNVdFUkdsiCUu"
Mime-Version: 1.0
Subject: pull-request: iwlwifi firmwares update 2017-10-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nVxzS99lNVdFUkdsiCUu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kyle,

I have updated the firmwares for the 3160, 3168, 7260, 7265D, 8000C and
8265 devices.

Please pull or let me know if there are any issues.

Cheers,
Luca.


The following changes since commit bf04291309d3169c0ad3b8db52564235bbd08e30=
:

  WHENCE: Add new qed firmware (2017-10-09 18:03:26 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
tags/iwlwifi-fw-2017-10-13

for you to fetch changes up to 97a3e95ecd6439790d2cfe14a32af7a21714800d:

  iwlwifi: update firmwares for 3160, 3168, 7265D, 8000C and 8265 (2017-10-=
13 14:22:26 +0300)

----------------------------------------------------------------
Update firmwares for 3160, 3168, 7260, 7265D, 8000C and 8265

* update -17 for 3160 and 7260;
* update -29 for 3168 and 7265D;
* update -31 for 8000C and 8265.

----------------------------------------------------------------
Luca Coelho (1):
      iwlwifi: update firmwares for 3160, 3168, 7265D, 8000C and 8265

 WHENCE                 |  12 ++++++------
 iwlwifi-3160-17.ucode  | Bin 918268 -> 918268 bytes
 iwlwifi-3168-29.ucode  | Bin 1036372 -> 1036372 bytes
 iwlwifi-7260-17.ucode  | Bin 1049340 -> 1049340 bytes
 iwlwifi-7265D-29.ucode | Bin 1036528 -> 1036528 bytes
 iwlwifi-8000C-31.ucode | Bin 2309768 -> 2310116 bytes
 iwlwifi-8265-31.ucode  | Bin 2303024 -> 2307104 bytes
 7 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/WHENCE b/WHENCE
index b2dc6a10abb2..c8d1d4b4b15c 100644
--- a/WHENCE
+++ b/WHENCE
@@ -861,7 +861,7 @@ File: iwlwifi-7260-16.ucode
 Version 16.242414.0
=20
 File: iwlwifi-7260-17.ucode
-Version 17.459231.0
+Version 17.589903.0
=20
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -885,7 +885,7 @@ File: iwlwifi-3160-16.ucode
 Version 16.242414.0
=20
 File: iwlwifi-3160-17.ucode
-Version 17.459231.0
+Version 17.589903.0
=20
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
@@ -933,7 +933,7 @@ File: iwlwifi-7265D-27.ucode
 Version 27.541033.0
=20
 File: iwlwifi-7265D-29.ucode
-Version 29.541020.0
+Version 29.588277.0
=20
 File: iwlwifi-3168-21.ucode
 Version 21.302800.0
@@ -945,7 +945,7 @@ File: iwlwifi-3168-27.ucode
 Version 27.541033.0
=20
 File: iwlwifi-3168-29.ucode
-Version 29.541020.0
+Version 29.588277.0
=20
 File: iwlwifi-8000C-13.ucode
 Version: 25.30.13.0
@@ -963,7 +963,7 @@ File: iwlwifi-8000C-27.ucode
 Version 27.541033.0
=20
 File: iwlwifi-8000C-31.ucode
-Version 31.532993.0
+Version 31.560484.0
=20
 File: iwlwifi-8265-21.ucode
 Version 21.302800.0
@@ -975,7 +975,7 @@ File: iwlwifi-8265-27.ucode
 Version 27.541033.0
=20
 File: iwlwifi-8265-31.ucode
-Version 31.532993.0
+Version 31.560484.0
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
diff --git a/iwlwifi-3160-17.ucode b/iwlwifi-3160-17.ucode
index 90c8d6205d31..fb22aa9dc436 100644
Binary files a/iwlwifi-3160-17.ucode and b/iwlwifi-3160-17.ucode differ
diff --git a/iwlwifi-3168-29.ucode b/iwlwifi-3168-29.ucode
index c9ba02305754..3e9a166803bb 100644
Binary files a/iwlwifi-3168-29.ucode and b/iwlwifi-3168-29.ucode differ
diff --git a/iwlwifi-7260-17.ucode b/iwlwifi-7260-17.ucode
index db7b4c20bf67..4379a8effdca 100644
Binary files a/iwlwifi-7260-17.ucode and b/iwlwifi-7260-17.ucode differ
diff --git a/iwlwifi-7265D-29.ucode b/iwlwifi-7265D-29.ucode
index 711c170f6089..bcb6eafedbe6 100644
Binary files a/iwlwifi-7265D-29.ucode and b/iwlwifi-7265D-29.ucode differ
diff --git a/iwlwifi-8000C-31.ucode b/iwlwifi-8000C-31.ucode
index 00812b5c31e0..9b41e50b61ed 100644
Binary files a/iwlwifi-8000C-31.ucode and b/iwlwifi-8000C-31.ucode differ
diff --git a/iwlwifi-8265-31.ucode b/iwlwifi-8265-31.ucode
index f6cace11135c..608ec749ffe8 100644
Binary files a/iwlwifi-8265-31.ucode and b/iwlwifi-8265-31.ucode differ
--=-nVxzS99lNVdFUkdsiCUu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlngqIsACgkQoUecoho8
xfpiFg/+JG6LlbXRtTq4PVLIlu9IMAgjl0zDWk8viiBgM3mWuME+P2N1Gx1hKcPJ
cTgSqEAtw+JXKPVaw00e4Y0g/h22h0A/4igW+NUqpLZbSbsEbyRQl2oA4wviEJML
VQ4tjex2g8AID0ekPjzIrmQFqVyLdYCOImORCeaomkj+LWvjnxriKTxuD4tnPgtT
t9F9SofXjNO3jWaTXDv1Mts1BY/JRf6B2pWYVXI0ryTLr1SFzo72Mp0uHNLFMjGN
XQql+x1r4irMYWUxVqUeAiavK9N0UE6vCuqQjkG38WJFc6TceXnOGeUby3OWNpEE
RQdKTO8gYN/hyECEgGT0RjREaqFaNvSvwuM1FTdH5GJV5jhQNnyVVgG8ZQfbAkGA
SlwTjxg33EJ7Myz78LtxzbAMWw5NQ4sOBB4vpgYwjU2MY8Ui9pvcXDEyubBxfYZK
197IjHeIp1Y25WhCjXlrUWRfvid4dwY0XXvF7fK1mjviP3fmdpIloPK4IirB11H2
1lGNYiZsNO8A+oFA9Vq3Tc+LaDbVl8xPq0K2iRPmMksHN2Xb/WxFlLgESuRDimGj
mgQylKKcpJEbcutmLUK8Mhxhw1dPw2sdD85UIMSWB3zBznEAn3CfFIVnFt3IEuQN
4IC30bJ1IYXrxHZC/q0OjpkUOJW3a+nIyo3Vyqg+YG2/GIS8TgI=
=aBWs
-----END PGP SIGNATURE-----

--=-nVxzS99lNVdFUkdsiCUu--
