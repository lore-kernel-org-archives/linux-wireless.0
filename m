Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:40445 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756014Ab2F0RV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 13:21:59 -0400
Received: by bkwj4 with SMTP id j4so1293438bkw.36
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 10:21:54 -0700 (PDT)
Message-ID: <1340817712.1631.633.camel@cumari.coelho.fi> (sfid-20120627_192216_134507_745B2A0B)
Subject: linux-firmware: pull-request wl12xx 2012-06-27
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 27 Jun 2012 20:21:52 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KwqAg6Bd1jrG0Y/C70Lw"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KwqAg6Bd1jrG0Y/C70Lw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Here are some new versions of TI's WLAN firmwares.  Also a new one for a
new chip we started supporting recently.

Please let me know if there are any problems.


The following changes since commit 5f9710a5770ad1f741caa67f7e97b824fb51ef2c=
:

  Merge branch 'for-upstream' of git://git.chelsio.net/pub/git/linux-firmwa=
re (2012-06-15 03:10:25 +0100)

are available in the git repository at:


  git://github.com/TI-OpenLink/firmwares.git linux-firmware

for you to fetch changes up to 1a13941d63aae221fa7ab86b30a3b8fde7443364:

  wl18xx: add firmware for WiLink8 WLAN chips (2012-06-27 15:55:03 +0300)

----------------------------------------------------------------
Luciano Coelho (2):
      wl127x/wl128x: add new firmware series as version 5
      wl18xx: add firmware for WiLink8 WLAN chips

 WHENCE                              |   15 +++++++++++++++
 ti-connectivity/wl127x-fw-5-mr.bin  |  Bin 0 -> 348724 bytes
 ti-connectivity/wl127x-fw-5-plt.bin |  Bin 0 -> 347920 bytes
 ti-connectivity/wl127x-fw-5-sr.bin  |  Bin 0 -> 366968 bytes
 ti-connectivity/wl128x-fw-5-mr.bin  |  Bin 0 -> 353248 bytes
 ti-connectivity/wl128x-fw-5-plt.bin |  Bin 0 -> 358008 bytes
 ti-connectivity/wl128x-fw-5-sr.bin  |  Bin 0 -> 375884 bytes
 ti-connectivity/wl18xx-fw.bin       |  Bin 0 -> 413860 bytes
 8 files changed, 15 insertions(+)
 create mode 100644 ti-connectivity/wl127x-fw-5-mr.bin
 create mode 100644 ti-connectivity/wl127x-fw-5-plt.bin
 create mode 100644 ti-connectivity/wl127x-fw-5-sr.bin
 create mode 100644 ti-connectivity/wl128x-fw-5-mr.bin
diff --git a/WHENCE b/WHENCE
index c149576..9754ff5 100644
--- a/WHENCE
+++ b/WHENCE
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
@@ -1646,6 +1652,15 @@ File: ti-connectivity/wl128x-fw-4-mr.bin
 Version: 7.5.2.0.15 (Multi-role)
 File: ti-connectivity/wl128x-fw-4-plt.bin
 Version: 7.3.5.0.98 (PLT)
+File: ti-connectivity/wl128x-fw-5-sr.bin
+Version: 7.3.10.2.115 (Single-role)
+File: ti-connectivity/wl128x-fw-5-mr.bin
+Version: 7.5.7.0.27 (Multi-role)
+File: ti-connectivity/wl128x-fw-5-plt.bin
+Version: 7.3.10.2.115 (PLT-only)
+
+File: ti-connectivity/wl18xx-fw.bin
+Version: 8.2.0.0.100
=20
 File: ti-connectivity/wl127x-nvs.bin
 File: ti-connectivity/wl128x-nvs.bin
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


--=-KwqAg6Bd1jrG0Y/C70Lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP60EwAAoJEKFHnKIaPMX6xBAQAIJNaolD2N56gNGak5Hp7jJT
xGP5WmEkTIXfPjGCptE5NXvauAVP2VTEvSfixSGRW34dL8KQw1alE/sQaesY5VNG
ujEeTawsFR580z00JXIK63pVrlj+4Tk8RmgMmgqx5tQ87CGizDT3qZhGLhs5xeIK
P5t8YpVbkBbCpaH0KlmxCqP+NW2Cs1bglkWCFvyr2tR146Djrfby5LfmMyaE5TRQ
9VVzpuzQ9uLSNOUdRsXszmLaAIyOLaJ61MdCRP4zLyL5CIWjv+XpW3z6o+OlnUv7
BCOqV+h49oZkLFSljbptmkniTK0UC+D1PfmICELmCLUrn8T4a/tseD4JlUm8D21X
fMmqCuxCwJfop5ceOHsDaOpQoWITDSMkFpLiOibLB9HosU+bc4TyM31ZM808hraI
A/7KuUk8AmC/xeIc8Pio1qRvOT/kFyS0lpCj+udCsBmgDveip8KFmKALhAHdScLe
rfx/HdSy89MI+ftDyM/rASzHyn8AV1uuXqVxwBPNmSa4lqNMxOINbnBVRlvnRt+i
sil7mTTK4/eHCOdtuYCOjxdSbmeA9e1QTPV0rX0xffs6Cpkts6PI23NhfEv6HjTf
2RC8ThRjS7mg4OPnukhUfRShLHADFxMsr4XB31nBMG0AyTYTZdQAtP0LeWGGxvMI
9hjKmeXMiv7gRFtQHYQq
=r7xo
-----END PGP SIGNATURE-----

--=-KwqAg6Bd1jrG0Y/C70Lw--

