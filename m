Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63936 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbbFRSbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 14:31:00 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Lv, Jane" <jane.lv@intel.com>,
	"Guo, Chaohong" <chaohong.guo@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: pull request: add -13.ucode firmware for Intel Wireless
Date: Thu, 18 Jun 2015 18:30:55 +0000
Message-ID: <1434652237.4885.16.camel@intel.com> (sfid-20150618_203104_397287_0DFDBE0F)
References: <1434651812.4885.9.camel@intel.com>
In-Reply-To: <1434651812.4885.9.camel@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-y8394Z5/4OaE1GnmL70h"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-y8394Z5/4OaE1GnmL70h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

This is a pull request for a new version of the firmware for Intel
wireless devices. Note that with this new firmware, we are now adding
support for 3 new devices: 3165, 8260 and 4165.

I had sent a pull request a while ago, this one replaces the older one.
Since then, we have added bug fixes and we are now able to release
iwlwifi-8000C.ucode which support 8260 and 4165.

Please pull.

The following changes since commit 3161bfa479d5e9ed4f46b57df9bcecbbc4f8eb3c=
:

  linux-firmware: Update firmware patch for Intel Bluetooth 7260 (B3/B4) (2=
015-05-13 11:12:48 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
for-kyle

for you to fetch changes up to c6c4150eaaffef76d8e3a3be13c822f0e2cd4dc6:

  iwlwifi: add new -13 firmware for iwlmvm devices (2015-06-18 20:06:17 +03=
00)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: add new -13 firmware for iwlmvm devices

 LICENCE.iwlwifi_firmware |   2 +-
 WHENCE                   |  15 +++++++++++++++
 iwlwifi-3160-13.ucode    | Bin 0 -> 688616 bytes
 iwlwifi-7260-13.ucode    | Bin 0 -> 786920 bytes
 iwlwifi-7265-13.ucode    | Bin 0 -> 885224 bytes
 iwlwifi-7265D-13.ucode   | Bin 0 -> 1008692 bytes
 iwlwifi-8000C-13.ucode   | Bin 0 -> 1745176 bytes
 7 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 iwlwifi-3160-13.ucode
 create mode 100644 iwlwifi-7260-13.ucode
 create mode 100644 iwlwifi-7265-13.ucode
 create mode 100644 iwlwifi-7265D-13.ucode
 create mode 100644 iwlwifi-8000C-13.ucode

diff --git a/LICENCE.iwlwifi_firmware b/LICENCE.iwlwifi_firmware
index b168a60..2f19654 100644
--- a/LICENCE.iwlwifi_firmware
+++ b/LICENCE.iwlwifi_firmware
@@ -1,4 +1,4 @@
-Copyright (c) 2006-2014, Intel Corporation.
+Copyright (c) 2006-2015, Intel Corporation.
 All rights reserved.
=20
 Redistribution.  Redistribution and use in binary form, without
diff --git a/WHENCE b/WHENCE
index 312bc88..b8c6472 100644
--- a/WHENCE
+++ b/WHENCE
@@ -834,6 +834,9 @@ Version: 23.15.10.0
 File: iwlwifi-7260-12.ucode
 Version: 25.17.12.0
=20
+File: iwlwifi-7260-13.ucode
+Version: 25.30.13.0
+
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
=20
@@ -849,6 +852,9 @@ Version: 23.15.10.0
 File: iwlwifi-3160-12.ucode
 Version: 25.17.12.0
=20
+File: iwlwifi-3160-13.ucode
+Version: 25.30.13.0
+
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
=20
@@ -861,12 +867,21 @@ Version: 23.15.10.0
 File: iwlwifi-7265-12.ucode
 Version: 25.17.12.0
=20
+File: iwlwifi-7265-13.ucode
+Version: 25.30.13.0
+
 File: iwlwifi-7265D-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-7265D-12.ucode
 Version: 25.17.12.0
=20
+File: iwlwifi-7265D-13.ucode
+Version: 25.30.13.0
+
+File: iwlwifi-8000C-13.ucode
+Version: 25.30.13.0
+
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
 Also available from http://wireless.kernel.org/en/users/Drivers/iwlwifi#Fi=
rmware
diff --git a/iwlwifi-3160-13.ucode b/iwlwifi-3160-13.ucode
new file mode 100644
index 0000000..dd05ded
Binary files /dev/null and b/iwlwifi-3160-13.ucode differ
diff --git a/iwlwifi-7260-13.ucode b/iwlwifi-7260-13.ucode
new file mode 100644
index 0000000..06e3b7a
Binary files /dev/null and b/iwlwifi-7260-13.ucode differ
diff --git a/iwlwifi-7265-13.ucode b/iwlwifi-7265-13.ucode
new file mode 100644
index 0000000..d093495
Binary files /dev/null and b/iwlwifi-7265-13.ucode differ
diff --git a/iwlwifi-7265D-13.ucode b/iwlwifi-7265D-13.ucode
new file mode 100644
index 0000000..4bf6994
Binary files /dev/null and b/iwlwifi-7265D-13.ucode differ
diff --git a/iwlwifi-8000C-13.ucode b/iwlwifi-8000C-13.ucode
new file mode 100644
index 0000000..df97f12
Binary files /dev/null and b/iwlwifi-8000C-13.ucode differ


--=-y8394Z5/4OaE1GnmL70h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJVgw5NAAoJEC0Llv5uNjIBxtMQAKk0e4tceyzkGTcjspdD9SmS
okoVTupnXqRd4THj/8mOLLa48U6aXcfw+VyzRHw8mtX/PuX5H8IDe6qiWn9aUl+A
XwbZpPj27yNLetZxe3vnWckmbuIVQE639GYCLZtQqSFgkSEIIT+iL+YsZDWu7XYR
gVHS2nPfEIpGbmCFHw189AhBmxELWHtOjDjNGLRNBtwLGmugVX7bBAydG5RVZUxH
EmhoBUGnasuvX2nKRYjE9HzsPTimyfmH9b8Te1+soeZ5DFr/Gh7/SSLP7+KYtKJN
N0GdOwpkuX4JvC+mHvGc+0lXu7uMTk/B0RtnMMkzSpwDTOnUAvIYpRId1xf25H6w
gdYItlM8Dg4x1pc5arCn930hjhlrStuyOTQLoFyUYRK1H7eHv7pRJMLwlhnMQQKT
uXejM/ebb3ZmcGgqT6ZrN9tLV2zyi9q/Fo5rOmx2DeFI1+RK2KZPlevb9oWs7aOf
wlRCKejhGGKI6ZabBjsyBCJlKDqR78F+JFThmro0iJ6xjJjqfaWM/vxvmpKSP3G5
adqW4cEng2jYQ5lVyxDBCYyWtt3o1ln1Pw0CPxh+TSTIL7n6uCGqth75HtOuoYJo
UGyv5WXrQH8DLFbgwfI8K5NhhVH1+vOGkEg4pQ4FQgAoBFT4zUcQ+0UvsUSl5tpU
ZmOGS43iPlE/zABy5lJx
=pb24
-----END PGP SIGNATURE-----

--=-y8394Z5/4OaE1GnmL70h--
