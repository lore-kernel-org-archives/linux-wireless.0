Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbbECMaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 08:30:07 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Guo, Chaohong" <chaohong.guo@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: pull request: update for -12.ucode firmware for Intel WiFi devices
 driven by iwlmvm
Date: Sun, 3 May 2015 12:30:02 +0000
Message-ID: <1430656195.25666.8.camel@intel.com> (sfid-20150503_143225_438779_8A241E87)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-R24qHqBVRwkDv/rHply8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-R24qHqBVRwkDv/rHply8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear linux-firmware maintainers,

Intel released a new version of the firmware for the devices below:
3160, 7260 and 7265.
This release fixes disconnections and stability issues.

The following changes since commit ec89525b2ab65f1d5ae4f67e27f0d525ddedd2ef=
:

  firmware: WHENCE: note nvidia xusb.bin firmware versions (2015-04-10 11:0=
0:59 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
master

for you to fetch changes up to 888ea193da7f6e3f03758e89bd1785d3fa393760:

  iwlwifi: update -12.ucode for 3160 / 7260 / 7265 / 7265D (2015-05-03 15:0=
8:00 +0300)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update -12.ucode for 3160 / 7260 / 7265 / 7265D

 WHENCE                 |   8 ++++----
 iwlwifi-3160-12.ucode  | Bin 683996 -> 683996 bytes
 iwlwifi-7260-12.ucode  | Bin 782300 -> 782300 bytes
 iwlwifi-7265-12.ucode  | Bin 880604 -> 880604 bytes
 iwlwifi-7265D-12.ucode | Bin 1002800 -> 1002800 bytes
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/WHENCE b/WHENCE
index 8d81633..ca97c1c 100644
--- a/WHENCE
+++ b/WHENCE
@@ -832,7 +832,7 @@ File: iwlwifi-7260-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-7260-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -847,7 +847,7 @@ File: iwlwifi-3160-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-3160-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
@@ -859,13 +859,13 @@ File: iwlwifi-7265-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-7265-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 File: iwlwifi-7265D-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-7265D-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
diff --git a/iwlwifi-3160-12.ucode b/iwlwifi-3160-12.ucode
index 45bce48..84b1bad 100644
Binary files a/iwlwifi-3160-12.ucode and b/iwlwifi-3160-12.ucode differ
diff --git a/iwlwifi-7260-12.ucode b/iwlwifi-7260-12.ucode
index 7ec91f0..a5da1d2 100644
Binary files a/iwlwifi-7260-12.ucode and b/iwlwifi-7260-12.ucode differ
diff --git a/iwlwifi-7265-12.ucode b/iwlwifi-7265-12.ucode
index 84ae2ce..7a9a579 100644
Binary files a/iwlwifi-7265-12.ucode and b/iwlwifi-7265-12.ucode differ
diff --git a/iwlwifi-7265D-12.ucode b/iwlwifi-7265D-12.ucode
index 3f36b55..cd2c1e0 100644
Binary files a/iwlwifi-7265D-12.ucode and b/iwlwifi-7265D-12.ucode differ
The following changes since commit ec89525b2ab65f1d5ae4f67e27f0d525ddedd2ef=
:

  firmware: WHENCE: note nvidia xusb.bin firmware versions (2015-04-10 11:0=
0:59 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
master

for you to fetch changes up to 888ea193da7f6e3f03758e89bd1785d3fa393760:

  iwlwifi: update -12.ucode for 3160 / 7260 / 7265 / 7265D (2015-05-03 15:0=
8:00 +0300)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update -12.ucode for 3160 / 7260 / 7265 / 7265D

 WHENCE                 |   8 ++++----
 iwlwifi-3160-12.ucode  | Bin 683996 -> 683996 bytes
 iwlwifi-7260-12.ucode  | Bin 782300 -> 782300 bytes
 iwlwifi-7265-12.ucode  | Bin 880604 -> 880604 bytes
 iwlwifi-7265D-12.ucode | Bin 1002800 -> 1002800 bytes
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/WHENCE b/WHENCE
index 8d81633..ca97c1c 100644
--- a/WHENCE
+++ b/WHENCE
@@ -832,7 +832,7 @@ File: iwlwifi-7260-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-7260-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -847,7 +847,7 @@ File: iwlwifi-3160-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-3160-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
@@ -859,13 +859,13 @@ File: iwlwifi-7265-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-7265-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 File: iwlwifi-7265D-10.ucode
 Version: 23.15.10.0
=20
 File: iwlwifi-7265D-12.ucode
-Version: 25.15.12.0
+Version: 25.17.12.0
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
diff --git a/iwlwifi-3160-12.ucode b/iwlwifi-3160-12.ucode
index 45bce48..84b1bad 100644
Binary files a/iwlwifi-3160-12.ucode and b/iwlwifi-3160-12.ucode differ
diff --git a/iwlwifi-7260-12.ucode b/iwlwifi-7260-12.ucode
index 7ec91f0..a5da1d2 100644
Binary files a/iwlwifi-7260-12.ucode and b/iwlwifi-7260-12.ucode differ
diff --git a/iwlwifi-7265-12.ucode b/iwlwifi-7265-12.ucode
index 84ae2ce..7a9a579 100644
Binary files a/iwlwifi-7265-12.ucode and b/iwlwifi-7265-12.ucode differ
diff --git a/iwlwifi-7265D-12.ucode b/iwlwifi-7265D-12.ucode
index 3f36b55..cd2c1e0 100644
Binary files a/iwlwifi-7265D-12.ucode and b/iwlwifi-7265D-12.ucode differ


--=-R24qHqBVRwkDv/rHply8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJVRhTDAAoJEC0Llv5uNjIBkYkP/0ZQ0ZUIvIhdwJ133yXj27Ya
JYgLNmTfl87u/Dt3+JcMdyEGREHG8w5zDyk9xxDIzbewZlBw8oqMmk+0Ql431BK+
I7Nnm7QRhHrKV/m9swKUIOvmyYs7nkWZqkfTtBLpQb0+FdwgOmLgYtqKUgekSq5S
jeuLHMqAV/uowQbcvUhUcS4KLugZgJXQIqsdZz9Q1gdTkSTTiGSllJlRc2RihX5B
89zwrpFW/8pz3WpHlmUKxbdUSpTgjvzINuVONIkQ+RH3v2kBDtLglEnGF7/BTja9
NQTVEHyFTH9nS80NhbjGxui9QvX6PhD49s5mSVUYqkCHI2v4SpfslBZ8zcOZm7vU
N/HrNYv+kg43G9C/ktEMCsD2At7NC9gOgP99TzA67o/YI8jBzC5tRBjhhXf6IpkB
bYp1UD+/enuduiWet0wLaKF51fBXtqtYk78iWcOi2sOkzq2Z5zj+QXH04DV4LTdQ
GjTsJXwkCqU1FK1vdQpL4OZusgwFhMhIbaUAdDlBCJgF5KM3IFRjBDuyEvj1P95/
PwWwVkLsl5AIV6a4/etEWWt39J7mEmUHtCEQNdhCuhKAH6Xs2RhyHnFNHRMUq7Wx
NGS0aa2t2q/lMKl/b7ObPGfYMBLb+rXXGIV2C0IHkkLhP5Jjeo5XLkI011+IyKAE
ahB48t/f+OudSHunfoOy
=Anxo
-----END PGP SIGNATURE-----

--=-R24qHqBVRwkDv/rHply8--
