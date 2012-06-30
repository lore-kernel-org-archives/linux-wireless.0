Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:58920 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446Ab2F3QGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 12:06:49 -0400
Received: by lbjn8 with SMTP id n8so6975263lbj.0
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jun 2012 09:06:46 -0700 (PDT)
Message-ID: <1341072404.1631.758.camel@cumari.coelho.fi> (sfid-20120630_180715_391877_913D2987)
Subject: linux-firmware: pull-request wl12xx 2012-06-27 (v2)
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, arik@wizery.com
Date: Sat, 30 Jun 2012 19:06:44 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1PNn0veTFqcIR77sg7xh"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1PNn0veTFqcIR77sg7xh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Here's v2 of my pull-request with a new section for wl18xx in the WHENCE
file, as you requested.

Please let me know if there are any more problems.


The following changes since commit 5f9710a5770ad1f741caa67f7e97b824fb51ef2c=
:

  Merge branch 'for-upstream' of git://git.chelsio.net/pub/git/linux-firmwa=
re (2012-06-15 03:10:25 +0100)

are available in the git repository at:


  git://github.com/TI-OpenLink/firmwares.git linux-firmware

for you to fetch changes up to 4384c8a7bda1bfdca92526004dd1aa9a3f33c209:

  wl18xx: add firmware for WiLink8 WLAN chips (2012-06-30 18:58:41 +0300)

----------------------------------------------------------------
Luciano Coelho (2):
      wl127x/wl128x: add new firmware series as version 5
      wl18xx: add firmware for WiLink8 WLAN chips

 WHENCE                              |   29 +++++++++++++++++++++++++++--
 ti-connectivity/wl127x-fw-5-mr.bin  |  Bin 0 -> 348724 bytes
 ti-connectivity/wl127x-fw-5-plt.bin |  Bin 0 -> 347920 bytes
 ti-connectivity/wl127x-fw-5-sr.bin  |  Bin 0 -> 366968 bytes
 ti-connectivity/wl128x-fw-5-mr.bin  |  Bin 0 -> 353248 bytes
 ti-connectivity/wl128x-fw-5-plt.bin |  Bin 0 -> 358008 bytes
 ti-connectivity/wl128x-fw-5-sr.bin  |  Bin 0 -> 375884 bytes
 ti-connectivity/wl18xx-fw.bin       |  Bin 0 -> 413860 bytes
 8 files changed, 27 insertions(+), 2 deletions(-)
 create mode 100644 ti-connectivity/wl127x-fw-5-mr.bin
 create mode 100644 ti-connectivity/wl127x-fw-5-plt.bin
 create mode 100644 ti-connectivity/wl127x-fw-5-sr.bin
 create mode 100644 ti-connectivity/wl128x-fw-5-mr.bin
 create mode 100644 ti-connectivity/wl128x-fw-5-plt.bin
 create mode 100644 ti-connectivity/wl128x-fw-5-sr.bin
 create mode 100644 ti-connectivity/wl18xx-fw.bin

diff --git a/WHENCE b/WHENCE
index c149576..fb6030c 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1613,7 +1613,7 @@ Licence: Redistributable. See LICENCE.tda7706-firmwar=
e.txt for details.
=20
 --------------------------------------------------------------------------
=20
-Driver: wl12xx - Texas Instruments 802.11 wireless LAN driver
+Driver: wl12xx - Texas Instruments 802.11 WLAN driver for WiLink6/7 chips
=20
 File: ti-connectivity/wl1271-fw.bin
 Version: 6.1.0.50.350 (STA-only)
@@ -1631,6 +1631,12 @@ File: ti-connectivity/wl127x-fw-4-mr.bin
 Version: 6.5.2.0.15 (Multi-role)
 File: ti-connectivity/wl127x-fw-4-plt.bin
 Version: 6.3.5.0.98 (PLT-only)
+File: ti-connectivity/wl127x-fw-5-sr.bin
+Version: 6.3.10.2.115 (Single-role)
+File: ti-connectivity/wl127x-fw-5-mr.bin
+Version: 6.5.7.0.27 (Multi-role)
+File: ti-connectivity/wl127x-fw-5-plt.bin
+Version: 6.3.10.2.115 (PLT-only)
=20
 File: ti-connectivity/wl128x-fw.bin
 Version: 7.1.5.50.74 (STA-only)
@@ -1646,13 +1652,18 @@ File: ti-connectivity/wl128x-fw-4-mr.bin
 Version: 7.5.2.0.15 (Multi-role)
 File: ti-connectivity/wl128x-fw-4-plt.bin
 Version: 7.3.5.0.98 (PLT)
+File: ti-connectivity/wl128x-fw-5-plt.bin
+Version: 7.3.10.2.115 (PLT-only)
=20
 File: ti-connectivity/wl127x-nvs.bin
 File: ti-connectivity/wl128x-nvs.bin
 sl:   ti-connectivity/wl12xx-nvs.bin -> wl127x-nvs.bin
 sl:   ti-connectivity/wl1271-nvs.bin -> wl127x-nvs.bin
=20
-
 Licence: See LICENCE.ti-connectivity for details.
=20
 The NVS file includes two parts:
@@ -1676,6 +1687,20 @@ the firmwares for wl12xx chips must be located in
=20
 --------------------------------------------------------------------------
=20
+Driver: wl18xx - Texas Instruments 802.11 WLAN driver for WiLink8 chips
+
+File: ti-connectivity/wl18xx-fw.bin
+Version: 8.2.0.0.100
+
+Licence: See LICENCE.ti-connectivity for details.
+
+The driver expects to find the firmwares under a ti-connectivity
+subdirectory.  So if your system looks for firmwares in /lib/firmware,
+the firmwares for wl18xx chips must be located in
+/lib/firmware/ti-connectivity/.
+
+--------------------------------------------------------------------------
+
 Driver: TI_ST - Texas Instruments bluetooth driver
=20
 File: ti-connectivity/TIInit_7.2.31.bts
diff --git a/ti-connectivity/wl127x-fw-5-mr.bin b/ti-connectivity/wl127x-fw=
-5-mr.bin
new file mode 100644
index 0000000..a19fb1e
Binary files /dev/null and b/ti-connectivity/wl127x-fw-5-mr.bin differ
diff --git a/ti-connectivity/wl127x-fw-5-plt.bin b/ti-connectivity/wl127x-f=
w-5-plt.bin
new file mode 100644
index 0000000..cd1cf33
Binary files /dev/null and b/ti-connectivity/wl127x-fw-5-plt.bin differ
diff --git a/ti-connectivity/wl127x-fw-5-sr.bin b/ti-connectivity/wl127x-fw=
-5-sr.bin
new file mode 100644
index 0000000..829088a
Binary files /dev/null and b/ti-connectivity/wl127x-fw-5-sr.bin differ
diff --git a/ti-connectivity/wl128x-fw-5-mr.bin b/ti-connectivity/wl128x-fw=
-5-mr.bin
new file mode 100644
index 0000000..0a062a8
Binary files /dev/null and b/ti-connectivity/wl128x-fw-5-mr.bin differ
diff --git a/ti-connectivity/wl128x-fw-5-plt.bin b/ti-connectivity/wl128x-f=
w-5-plt.bin
new file mode 100644
index 0000000..d8ac6fa
Binary files /dev/null and b/ti-connectivity/wl128x-fw-5-plt.bin differ
diff --git a/ti-connectivity/wl128x-fw-5-sr.bin b/ti-connectivity/wl128x-fw=
-5-sr.bin
new file mode 100644
index 0000000..75d5a4f
Binary files /dev/null and b/ti-connectivity/wl128x-fw-5-sr.bin differ
diff --git a/ti-connectivity/wl18xx-fw.bin b/ti-connectivity/wl18xx-fw.bin
new file mode 100644
index 0000000..ac1e24e
Binary files /dev/null and b/ti-connectivity/wl18xx-fw.bin differ

--=20
Cheers,
Luca.

--=-1PNn0veTFqcIR77sg7xh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7yQUAAoJEKFHnKIaPMX6WRYP/1gPGy+M4/7NRMN0MLuNXglc
2pPmh8Bn//xzm2he15kkwI7sozy0qrliakhuuPy7Na0SIdwesfhF2NAiu3EEfclg
/9As/WUlEImOY7DpU3Hi/HhDRObbaqYszu9WswsNRIcaHBAUXqBeTLEZIbJyewwb
iz50K/CKOPjFIFyyW9A6CHRcmc6H8GMISToyM0IzE9JFweQ45e3cBK2IztxP9quE
X4qnWhEqiQRvk+CoieZSdt2EB0wamiLLuGXtQRhtpISjreJynJeGDbe61MCH60Hm
rFBlDBjtcsnGI4IsX4XJS2YrVJzfh1V9PgdqbWKdRVNyFgrJUkpATP4/d8fCERUx
NbIXo6XX271VYI243y/EZDyuM/+LbY9YS/4NeGbpnKmN85p7UKcXeneKcOKMecnU
vc/aaQm3ja8DCtlPX4aGr/OTAiWxuTejkAIyasdsmBhZUcmGqw58hFEKs57jNgFQ
tk1GFT8EihZTulR6MSje32ubV/n0cGUNM1dWbMFijjzxYAtgBqQFrLRBkjMVRwfs
YhOx92pHpQ8yI0RU9tDjVBG7TWbeS6Um7OHGGP1GE694cxejP3Gl0RZ0HxwbUr6k
8KbSKc17l/JyEvQDh/7lznZOYBz6ip+G8TNXPtxwUp+6ahoRib3UnaX842LKaH4h
decFT3lW/8ZaKoFP5qm/
=bgO8
-----END PGP SIGNATURE-----

--=-1PNn0veTFqcIR77sg7xh--

