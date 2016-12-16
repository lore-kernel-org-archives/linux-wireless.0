Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35760 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760970AbcLPLSl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 06:18:41 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gery Kahn <gery.kahn@gmail.com>, Shahar Lev <shahar@wizery.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: Re: wl1251 NVS calibration data format
Date: Fri, 16 Dec 2016 12:12:31 +0100
References: <201612161201.48356@pali>
In-Reply-To: <201612161201.48356@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart19504915.RAnl7KHRZq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201612161212.31581@pali> (sfid-20161216_121911_968227_06864483)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart19504915.RAnl7KHRZq
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Resending email to new Gery's address...

On Friday 16 December 2016 12:01:48 Pali Roh=C3=A1r wrote:
> Hi! Do you know format of wl1251 NVS calibration data file?
>=20
> I found that there is tool for changing NVS file for wl1271 and newer=20
> chips (so not for wl1251!) at: https://github.com/gxk/ti-utils
>=20
> And wl1271 has in NVS data already place for MAC address. And in wlcore=20
> (for wl1271 and newer) there is really kernel code which is doing=20
> something with MAC address in NVS, see:=20
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/driv=
ers/net/wireless/ti/wlcore/boot.c#n352

Also, there is parsing MAC address from NVS wl1271 data:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/driver=
s/net/wireless/ti/wlcore/main.c#n6009

> So... I would like to know if in wl1251 NVS calibration file is also=20
> some place for MAC address or not.
>=20
> Default wl1251 NVS calibration file is available in linux-firmware:=20
> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/=
tree/ti-connectivity/wl1251-nvs.bin

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart19504915.RAnl7KHRZq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlhTzB8ACgkQi/DJPQPkQ1KaHACfZLfd8yQFhwRtUD2kfgypZzxo
Nm0An2kv5hOHqVNX3X7DM27Cin0CYDeB
=mX/V
-----END PGP SIGNATURE-----

--nextPart19504915.RAnl7KHRZq--
