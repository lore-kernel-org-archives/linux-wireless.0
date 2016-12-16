Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33621 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754110AbcLPLEB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 06:04:01 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gery Kahn <geryk@ti.com>, Shahar Lev <shahar@wizery.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: wl1251 NVS calibration data format
Date: Fri, 16 Dec 2016 12:01:48 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12672099.PnFCeYFKkR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201612161201.48356@pali> (sfid-20161216_120456_202266_1CD0A788)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart12672099.PnFCeYFKkR
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi! Do you know format of wl1251 NVS calibration data file?

I found that there is tool for changing NVS file for wl1271 and newer=20
chips (so not for wl1251!) at: https://github.com/gxk/ti-utils

And wl1271 has in NVS data already place for MAC address. And in wlcore=20
(for wl1271 and newer) there is really kernel code which is doing=20
something with MAC address in NVS, see:=20
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/driver=
s/net/wireless/ti/wlcore/boot.c#n352

So... I would like to know if in wl1251 NVS calibration file is also=20
some place for MAC address or not.

Default wl1251 NVS calibration file is available in linux-firmware:=20
https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tr=
ee/ti-connectivity/wl1251-nvs.bin

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart12672099.PnFCeYFKkR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlhTyZwACgkQi/DJPQPkQ1JBkgCeM46e33Ht7Gadp0git2HSFknS
p5UAoKgURIPXzLlMT1oewT5hLM0qa/7M
=GLUu
-----END PGP SIGNATURE-----

--nextPart12672099.PnFCeYFKkR--
