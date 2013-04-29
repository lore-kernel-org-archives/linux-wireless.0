Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35121 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab3D2KF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 06:05:59 -0400
Message-ID: <1367229856.30716.22.camel@cumari.coelho.fi> (sfid-20130429_120606_177870_5BCED954)
Subject: linux-firmware: pull-request TI wireless firmwares 2012-04-29
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>,
	<linux-wireless@vger.kernel.org>
Date: Mon, 29 Apr 2013 13:04:16 +0300
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-PTbpc5WS+XFV31LzQszW"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-PTbpc5WS+XFV31LzQszW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Here are some updates to our wireless firmwares.  Updated the firmwares
for WiLink 6 and 7 and added a new version of the firmware for WiLink 8
and a binary configuration file.  Also updated the WHENCE file
accordingly.

Please let me know if there are any more problems.


The following changes since commit 120a97ff309b6a20812f13d0f9da231eacc3311a=
:

  Add Intel Bluetooth firmware patch files (2013-04-29 10:06:34 +0100)

are available in the git repository at:

  git://github.com/TI-OpenLink/firmwares.git linux-firmware

for you to fetch changes up to 07ac844ff005c6c38623db831c27e704b0c709c0:

  wl18xx: add default configuration binary (2013-04-29 12:47:04 +0300)

----------------------------------------------------------------
Luciano Coelho (3):
      wl127x/wl128x: update firmwares
      wl18xx: add version 2 of the wl18xx firmware
      wl18xx: add default configuration binary

 WHENCE                              |   16 ++++++++++------
 ti-connectivity/wl127x-fw-5-mr.bin  |  Bin 348724 -> 354600 bytes
 ti-connectivity/wl127x-fw-5-plt.bin |  Bin 347920 -> 352588 bytes
 ti-connectivity/wl127x-fw-5-sr.bin  |  Bin 366968 -> 370996 bytes
 ti-connectivity/wl128x-fw-5-mr.bin  |  Bin 353248 -> 359140 bytes
 ti-connectivity/wl128x-fw-5-plt.bin |  Bin 358008 -> 360452 bytes
 ti-connectivity/wl128x-fw-5-sr.bin  |  Bin 375884 -> 378988 bytes
 ti-connectivity/wl18xx-conf.bin     |  Bin 0 -> 1221 bytes
 ti-connectivity/wl18xx-fw-2.bin     |  Bin 0 -> 639276 bytes
 9 files changed, 10 insertions(+), 6 deletions(-)
 create mode 100644 ti-connectivity/wl18xx-conf.bin
 create mode 100644 ti-connectivity/wl18xx-fw-2.bin

diff --git a/WHENCE b/WHENCE
index 4726742..257f24e 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1681,11 +1681,11 @@ Version: 6.5.2.0.15 (Multi-role)
 File: ti-connectivity/wl127x-fw-4-plt.bin
 Version: 6.3.5.0.98 (PLT-only)
 File: ti-connectivity/wl127x-fw-5-sr.bin
-Version: 6.3.10.2.115 (Single-role)
+Version: 6.3.10.0.133 (Single-role)
 File: ti-connectivity/wl127x-fw-5-mr.bin
-Version: 6.5.7.0.27 (Multi-role)
+Version: 6.5.7.0.42 (Multi-role)
 File: ti-connectivity/wl127x-fw-5-plt.bin
-Version: 6.3.10.2.115 (PLT-only)
+Version: 6.3.10.0.133 (PLT-only)
=20
 File: ti-connectivity/wl128x-fw.bin
 Version: 7.1.5.50.74 (STA-only)
@@ -1702,11 +1702,11 @@ Version: 7.5.2.0.15 (Multi-role)
 File: ti-connectivity/wl128x-fw-4-plt.bin
 Version: 7.3.5.0.98 (PLT)
 File: ti-connectivity/wl128x-fw-5-sr.bin
-Version: 7.3.10.2.115 (Single-role)
+Version: 7.3.10.0.133 (Single-role)
 File: ti-connectivity/wl128x-fw-5-mr.bin
-Version: 7.5.7.0.27 (Multi-role)
+Version: 7.5.7.0.42 (Multi-role)
 File: ti-connectivity/wl128x-fw-5-plt.bin
-Version: 7.3.10.2.115 (PLT-only)
+Version: 7.3.10.2.133 (PLT-only)
=20
 File: ti-connectivity/wl127x-nvs.bin
 File: ti-connectivity/wl128x-nvs.bin
@@ -1740,6 +1740,10 @@ Driver: wl18xx - Texas Instruments 802.11 WLAN drive=
r for WiLink8 chips
=20
 File: ti-connectivity/wl18xx-fw.bin
 Version: 8.2.0.0.100
+File: ti-connectivity/wl18xx-fw-2.bin
+Version: 8.5.0.0.55
+File: ti-connectivity/wl18xx-conf.bin
+Version: 6/5
=20
 Licence: See LICENCE.ti-connectivity for details.
=20
diff --git a/ti-connectivity/wl127x-fw-5-mr.bin b/ti-connectivity/wl127x-fw=
-5-mr.bin
index a19fb1e..c953fef 100644
Binary files a/ti-connectivity/wl127x-fw-5-mr.bin and b/ti-connectivity/wl1=
27x-fw-5-mr.bin differ
diff --git a/ti-connectivity/wl127x-fw-5-plt.bin b/ti-connectivity/wl127x-f=
w-5-plt.bin
index cd1cf33..1f6249f 100644
Binary files a/ti-connectivity/wl127x-fw-5-plt.bin and b/ti-connectivity/wl=
127x-fw-5-plt.bin differ
diff --git a/ti-connectivity/wl127x-fw-5-sr.bin b/ti-connectivity/wl127x-fw=
-5-sr.bin
index 829088a..c83d3eb 100644
Binary files a/ti-connectivity/wl127x-fw-5-sr.bin and b/ti-connectivity/wl1=
27x-fw-5-sr.bin differ
diff --git a/ti-connectivity/wl128x-fw-5-mr.bin b/ti-connectivity/wl128x-fw=
-5-mr.bin
index 0a062a8..14931ed 100644
Binary files a/ti-connectivity/wl128x-fw-5-mr.bin and b/ti-connectivity/wl1=
28x-fw-5-mr.bin differ
diff --git a/ti-connectivity/wl128x-fw-5-plt.bin b/ti-connectivity/wl128x-f=
w-5-plt.bin
index d8ac6fa..54232d0 100644
Binary files a/ti-connectivity/wl128x-fw-5-plt.bin and b/ti-connectivity/wl=
128x-fw-5-plt.bin differ
diff --git a/ti-connectivity/wl128x-fw-5-sr.bin b/ti-connectivity/wl128x-fw=
-5-sr.bin
index 75d5a4f..e10a1ba 100644
Binary files a/ti-connectivity/wl128x-fw-5-sr.bin and b/ti-connectivity/wl1=
28x-fw-5-sr.bin differ
diff --git a/ti-connectivity/wl18xx-conf.bin b/ti-connectivity/wl18xx-conf.=
bin
new file mode 100644
index 0000000..d3d2473
Binary files /dev/null and b/ti-connectivity/wl18xx-conf.bin differ
diff --git a/ti-connectivity/wl18xx-fw-2.bin b/ti-connectivity/wl18xx-fw-2.=
bin
new file mode 100644
index 0000000..e2a56f5
Binary files /dev/null and b/ti-connectivity/wl18xx-fw-2.bin differ

--=20
Cheers,
Luca.


--=-PTbpc5WS+XFV31LzQszW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJRfkWgAAoJEKFHnKIaPMX6RIAQAJIZBxV7SOwej09KBK2YitSv
N+ZFQjG9gYpO5j1e00THK31QcZdVZmOIpQ9Og2Qisli6z6XL9qcPZm4s9uWiugWU
nueNP/GAs80wARgIhW73LnPpbltHxtT6PnU5S96FA5C/Dk0Ci8yvt8208n2uDEX5
eAnvLxb5KPxZ8x/OSOjS2+89ldLMQ36GfC55TuXU2ya28l5atnu+LzEYYKPL6DCC
m5x4fHV0hJqtWf2iuiThPpMUlY63S8Q1MNIH0I/782QSqU2ZGoPwk7tmw0jzJ+ZQ
ggkPam7Uirxso/MMkZ9YcmueDgJTFf10NAG9DLB+LGuxvfjc4RU/yIgiMBIEVBvO
S9JEtT8upWBe6mrOJq2fnRp3yURmB4cboPgoxRGQwvX/yQZ3s/U+y5tsl7kCVRVl
VdybN2+XuXyDyPQbSGK704KAGx0i9/LXUqTfiTDfaKd7Br3aL3xmrkrsHpF1qViq
WbnbpyqGV8WvCBJX5LPHY3eiBk1ddqksObtRsT4OUUkLsAqe6wGQ1fY+Af/JYJ/1
Me05Sv2tRchtaen/u3fz9ZkHPrOS4At59vlNbc0OVy+qW20jcAudOGcpHY0pqIMz
RBuhuytRq4NOJZ0/aqGGDyCLY9Z4AnogNgzfPInPUtkMk5pi1D50ePYXld+jx3gE
+w6Iff86szEUswW69ueD
=PcbF
-----END PGP SIGNATURE-----

--=-PTbpc5WS+XFV31LzQszW--
