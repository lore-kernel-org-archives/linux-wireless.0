Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32773 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcKZRVZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Nov 2016 12:21:25 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: wl1251 & mac address & calibration data
Date: Sat, 26 Nov 2016 18:20:47 +0100
Cc: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <201611111820.52072@pali> <20161124152045.GK13735@pali> <20161124184601.wo4al6nyzb6rmiqs@raspberrypi-2.musicnaut.iki.fi>
In-Reply-To: <20161124184601.wo4al6nyzb6rmiqs@raspberrypi-2.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1551961.ahafGneisu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201611261820.47995@pali> (sfid-20161126_182130_530588_E004A0CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1551961.ahafGneisu
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 24 November 2016 19:46:01 Aaro Koskinen wrote:
> Hi,
>=20
> On Thu, Nov 24, 2016 at 04:20:45PM +0100, Pali Roh=C3=A1r wrote:
> > Proprietary, signed and closed bootloader NOLO does not support DT.
> > So for booting you need to append DTS file to kernel image.
> >=20
> > U-Boot is optional and can be used as intermediate bootloader
> > between NOLO and kernel. But still it has problems with reading
> > from nand, so cannot read NVS data nor MAC address.
>=20
> You could use kexec to pass the fixed DT.
>=20
> A.

IIRC it was broken for N900/omap3, no idea if somebody fixed it.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1551961.ahafGneisu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlg5xG8ACgkQi/DJPQPkQ1KHZACePTQRcNym7IEI7ws6eenBNR6t
rEEAn0orVjV+21VfN2jIpBXfChCxrTaW
=lO6H
-----END PGP SIGNATURE-----

--nextPart1551961.ahafGneisu--
