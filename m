Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZDQMIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 08:08:53 -0400
Subject: Re: p54 problem with PS
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <200904171356.58336.chunkeey@web.de>
References: <1239823495.20927.1.camel@johannes.local>
	 <200904162157.20576.chunkeey@web.de>
	 <1239913104.26575.25.camel@johannes.local>
	 <200904171356.58336.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9LVbczwHrnZrebq6P6dX"
Date: Fri, 17 Apr 2009 14:08:18 +0200
Message-Id: <1239970098.26575.88.camel@johannes.local> (sfid-20090417_140856_859299_B420414B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9LVbczwHrnZrebq6P6dX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-17 at 13:56 +0200, Christian Lamparter wrote:
> On Thursday 16 April 2009 22:18:24 Johannes Berg wrote:
> >=20
> > > Well, I guess I figured out what's wrong: the hw spec.
> > > So this patch might work on PCI & USB, but could break SPI devices.
> >=20
> > Heh.
> >=20
> > > Johannes, can you please test the attached patch?
> > >=20
>=20
> updated version.

Loads of "Fake beacon loss" but works. :)

johannes

--=-9LVbczwHrnZrebq6P6dX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6HEwAAoJEKVg1VMiehFYUhoP/RGa1zGHnfnMCJGg+LxmJ0Q8
FJHzqzZZRt+Buv3aLCv4L3m6jsb81FeUni6aH+8Jnv/7z/nI1OG3ACrrOMMbVUjg
RqRnGK50ZX1eAQzmWugU/NF8X7d7hap9kz1KMDJ/YuuPFa951avN8rkGbyiraVL+
2lq8JaLjkfEPIj/HYCROaor1IaY/p/7vpO4+ER37QfeOA7eNrrRjHd2j49PJP0eY
cFcywDzkUA1X6W951bBajgHdF/fDBHwT70PQFRuKYLTn/VXSck8dobK+/siBhIPj
oGVvC+RCkWcpjQFcDvqfkqpNQmSnksUHB0nWVHmovRqG9FvZKU+xtF/YUYrmVhVn
6K7uXT6F9QgLsbWrN9hixzZVhtwyObuChqMozfeuc3OJDIQkWu34qEDt7HiU3cm0
CUuUZxatjn3iI5ROUR8SCd9pM8KXzOrYr1AVZmDPzLgyBYWtf34QYrlv35S9aCYD
uq5rs6k9Xw+WsntxrAAEkaS9anrilPLaZdMTox4xfZ5/tBcABK9iYZU7MYbMlCw0
hf7lCZlLFk063HV9a/LrF/M15ATM6feQH9KD9Z2x9jeTSMEX7OPotS2916lD4P0u
ZAwm3g9EDVtpr5Y8zwp/lWpr9cSjLNHJZ7dnQ8OOcUaEEOeEwpkKxegxn9w/VMVO
Hp3GLr4aBZC1RN4J2jzO
=WM3h
-----END PGP SIGNATURE-----

--=-9LVbczwHrnZrebq6P6dX--

