Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbbBCVje (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 16:39:34 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhao, Yingying" <yingying.zhao@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: pull request: new firmware for Intel wireless Intel 3160 / 7260 /
 7265 / 7265D devices
Date: Tue, 3 Feb 2015 21:39:28 +0000
Message-ID: <1422999568.29907.24.camel@egrumbacBox> (sfid-20150203_223937_759185_CB11B7E6)
References: <1422999252.29907.18.camel@egrumbacBox>
In-Reply-To: <1422999252.29907.18.camel@egrumbacBox>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-5xk67pR8ufyUOn3j064z"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-5xk67pR8ufyUOn3j064z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

This is a pull request for new firmwares for the Intel wireless devices
mentioned in the subject.

I replace -10.ucode with new ones (that includes bug fixes).
I add the brand new -12.ucode.

Please pull.

The following changes since commit
38e5405c96d10bb42b629b45210c46166461fc21:

  cxgb4: Update firmware to revision 1.12.25.0 (2014-12-01 15:48:02
-0500)

are available in the git repository at:


git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
master

for you to fetch changes up to da4e58d47557776c5721bafb3f2b6c4a1a4ff0f3:

  iwlwifi: add new -12 firmware for 3160 / 7260 / 7265 / 7265D
(2015-02-03 23:14:51 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D
      iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D
      iwlwifi: add new -12 firmware for 3160 / 7260 / 7265 / 7265D

 WHENCE                 |  20 ++++++++++++++++----
 iwlwifi-3160-10.ucode  | Bin 610168 -> 610064 bytes
 iwlwifi-3160-12.ucode  | Bin 0 -> 683996 bytes
 iwlwifi-7260-10.ucode  | Bin 672480 -> 672372 bytes
 iwlwifi-7260-12.ucode  | Bin 0 -> 782300 bytes
 iwlwifi-7265-10.ucode  | Bin 736968 -> 736864 bytes
 iwlwifi-7265-12.ucode  | Bin 0 -> 880604 bytes
 iwlwifi-7265D-10.ucode | Bin 740636 -> 740456 bytes
 iwlwifi-7265D-12.ucode | Bin 0 -> 1002800 bytes
 9 files changed, 16 insertions(+), 4 deletions(-)
 create mode 100644 iwlwifi-3160-12.ucode
 create mode 100644 iwlwifi-7260-12.ucode
 create mode 100644 iwlwifi-7265-12.ucode
 create mode 100644 iwlwifi-7265D-12.ucode

diff --git a/WHENCE b/WHENCE
index 44c41c7..1917288 100644
--- a/WHENCE
+++ b/WHENCE
@@ -816,7 +816,10 @@ File: iwlwifi-7260-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7260-10.ucode
-Version: 23.10.10.0
+Version: 23.12.10.0
+
+File: iwlwifi-7260-12.ucode
+Version: 25.15.12.0
=20
 File: iwlwifi-3160-7.ucode
 Version: 22.1.7.0
@@ -828,7 +831,10 @@ File: iwlwifi-3160-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-3160-10.ucode
-Version: 23.10.10.0
+Version: 23.12.10.0
+
+File: iwlwifi-3160-12.ucode
+Version: 25.15.12.0
=20
 File: iwlwifi-7265-8.ucode
 Version: 22.24.8.0
@@ -837,10 +843,16 @@ File: iwlwifi-7265-9.ucode
 Version: 25.228.9.0
=20
 File: iwlwifi-7265-10.ucode
-Version: 23.10.10.0
+Version: 23.12.10.0
+
+File: iwlwifi-7265-12.ucode
+Version: 25.15.12.0
=20
 File: iwlwifi-7265D-10.ucode
-Version: 23.10.10.0
+Version: 23.12.10.0
+
+File: iwlwifi-7265D-12.ucode
+Version: 25.15.12.0
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
index 8cec7bf..5f4173c 100644
Binary files a/iwlwifi-3160-10.ucode and b/iwlwifi-3160-10.ucode differ
diff --git a/iwlwifi-3160-12.ucode b/iwlwifi-3160-12.ucode
new file mode 100644
index 0000000..45bce48
Binary files /dev/null and b/iwlwifi-3160-12.ucode differ
diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
index 9e5b930..dca79e2 100644
Binary files a/iwlwifi-7260-10.ucode and b/iwlwifi-7260-10.ucode differ
diff --git a/iwlwifi-7260-12.ucode b/iwlwifi-7260-12.ucode
new file mode 100644
index 0000000..7ec91f0
Binary files /dev/null and b/iwlwifi-7260-12.ucode differ
diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
index 488ddd0..0571fcf 100644
Binary files a/iwlwifi-7265-10.ucode and b/iwlwifi-7265-10.ucode differ
diff --git a/iwlwifi-7265-12.ucode b/iwlwifi-7265-12.ucode
new file mode 100644
index 0000000..84ae2ce
Binary files /dev/null and b/iwlwifi-7265-12.ucode differ
diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
index 01194db..d9b9aaf 100644
Binary files a/iwlwifi-7265D-10.ucode and b/iwlwifi-7265D-10.ucode
differ
diff --git a/iwlwifi-7265D-12.ucode b/iwlwifi-7265D-12.ucode
new file mode 100644
index 0000000..3f36b55
Binary files /dev/null and b/iwlwifi-7265D-12.ucode differ


--=-5xk67pR8ufyUOn3j064z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJU0UAQAAoJEC0Llv5uNjIBlo0QAKTBe0Uy4GSZx0oeK0kfwV/L
2dJfrzSydwlh2/BMYQFssZ3/AsFZ8F7wgen+cUkLq9KJEskdC8BSw2FyxXzmF8X1
4lik93FfdzMQwG1TFTVPlHEbDDsJjSHnL+rUkR5SggoukhcwufriGukQ34fok0Qo
IrrcWLNAqPo6kM+fT9K1Mep5AgKh+XMszavPHngxYmdNHqlmWXHCEWFe+h1lhND+
n1iO5ANumE/Al4/5aTlPK/kIvaWKR9TpKSs6aKOv1BeG0fstOrPMc3xSUGoHh0OA
PO4dKvjGC4Moc/P1LX4ABzl03xGX/fDNxSXhl+E6x9QjxQbFibNDuLCCkeuLZhL2
W+tNdPijc3HddA3qXRiy7/r76410kYTkI0I3/mfQvmJy7CWvguMDaDBjBSZPjng5
bqAHZGfSaAm7ut+vEwlMCG3uO8RU17PsZ//zoeED15XnZ2b3M/FaopMhE3v4CLFi
7E7am4vXTPIW3+mvvfDZ8H/HoEAMxwX84CPDORLqwBYWyvXWv0aHFJe0Gnbpc1H6
0/YPXKpxL31aYLycmt/BGvD0qOWjH754/15/EghPD6uZ6YbbmaEN81fKPrdcnlz0
/d2il/wQKD6pXmvh3sJj+PeMQWsHO40PjdCMMJXmhZG/DZMy+vl6AUHk85KtUb9a
mDAdw4crJQ3YufLl+AST
=G67I
-----END PGP SIGNATURE-----

--=-5xk67pR8ufyUOn3j064z--
