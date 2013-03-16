Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51435 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3CPQsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 12:48:15 -0400
Message-ID: <5144A184.1060900@iki.fi> (sfid-20130316_174830_252782_D80B0A79)
Date: Sat, 16 Mar 2013 18:44:52 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
MIME-Version: 1.0
To: vishnu <vishnu.kopparapu@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: problem connecting to AP on new kernel (disassociating continuously
 after associating ) . Can some one please comment on the issue I am facing
References: <loom.20130315T140953-940@post.gmane.org>
In-Reply-To: <loom.20130315T140953-940@post.gmane.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2USDDMOSTGLRSHTLAQXQW"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2USDDMOSTGLRSHTLAQXQW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15.03.2013 15:29, vishnu wrote:
> Hello all,
>=20
> driver used : rtl8192cu
>=20
> When I tested with my linux kernel 3.0 , I didn't have any problems con=
necting=20
> to AP. But with kernel 3.6.8 , I had a problem . When I tested with 3.7=
=2E8 also I=20
> am facing the same problem. This is the latest kernel used by latest re=
lease of=20
> buildroot , so I didn't test any kernels after that version.
>=20
> The authentication and association are fine but from some reason it is =

> disassociating after that and it keeps repeating it and it never connec=
ts to the=20
> AP.
>=20

Have you tested this patch: http://marc.info/?l=3Dlinux-wireless&m=3D1363=
18849815054&w=3D2

It solves re-association issues that rtl8192cu had.

-Jussi




------enig2USDDMOSTGLRSHTLAQXQW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBCAAGBQJRRKGJAAoJEAaL+yOpMWaGEW4L/1FvJYqcGHw60ecmSus3hv3b
wlxyfPgGgDBKMEzmf7OLz/pRH0huWpgtsbdkSPt8d6XnvuGciO7FXG5CUJRsQ01j
uiDvwv09y9KeNhM3TKPMtCcfNvcJnxaDH3UsPd8htM5AP2rgiK+j9t63gB0qNS4u
HJuQaN4szdUsm/8iCMIPBOoPMTKHCK28c8Y2kT57eFhtzxa7tuUOuwK0QI2z/jdR
1jfQfq3Ww3jC9hLb41luh/EYU1zaKFnIPOO1ePW+/gJuTux1I6fvwKPsU8/XJgqC
y3Xvqe+HzeQ1xEEAa/bo9fx0xWrKqxF8MmI5oY3pduxZsTaLhiQmo72YpqPXvaOC
I3ajqfRZ5ra3Y5tItnq6e0S7TXs8rqcjgF2nE1aKObs2M7oydrUE4rzCcR8UBDv4
McJxkuyfpmo9qGY+fPR3hoSoP35GRyr3DKBtu3WjFN9tegP5UzTZg4xbgTGahOY6
iwCjNpWA27iLtm6IUw/7kGFi6Zx/Y+44T9e4umraOA==
=5OYm
-----END PGP SIGNATURE-----

------enig2USDDMOSTGLRSHTLAQXQW--
