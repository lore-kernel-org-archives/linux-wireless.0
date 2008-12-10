Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYLJRmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:42:22 -0500
Subject: Re: [PATCH] rfkill: strip pointless notifier chain
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200812101840.00480.IvDoorn@gmail.com> (sfid-20081210_184034_054500_8F394307)
References: <1228927728.15837.10.camel@johannes.berg>
	 <200812101801.35735.IvDoorn@gmail.com>
	 <1228929609.15837.36.camel@johannes.berg>
	 <200812101840.00480.IvDoorn@gmail.com>
	 (sfid-20081210_184034_054500_8F394307)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5rBa0Uh84xBaB08JBrI6"
Date: Wed, 10 Dec 2008 18:41:47 +0100
Message-Id: <1228930907.15837.50.camel@johannes.berg> (sfid-20081210_184225_170881_95C2D0A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5rBa0Uh84xBaB08JBrI6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 18:40 +0100, Ivo van Doorn wrote:
> On Wednesday 10 December 2008, Johannes Berg wrote:
> > On Wed, 2008-12-10 at 18:01 +0100, Ivo van Doorn wrote:
> > > On Wednesday 10 December 2008, Johannes Berg wrote:
> > > > No users, so no reason to have it.
> > >=20
> > > Henrique, you introduced the notifier chain, are there any upcoming
> > > users for it or can it indeed be removed?
> >=20
> > It can be added back with the users when needed.
>=20
> Fine, but I was more thinking about how soon would such an upcoming
> user arrive. There is no point in deleting the interface when it will
> be added within a couple of days.

Yeah, but it's been in there for a long time without users already, not
like it was added yesterday and the user will show up tomorrow.

johannes

--=-5rBa0Uh84xBaB08JBrI6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP/9YAAoJEKVg1VMiehFYqqgP/jE3tLs29/Etn8dyJ3PcaSIl
7S6N7NbvMHv2w4iIXIKBF2pKlWPoNDX5xptyT117vG0rnisuzV4i7QdVrrilfrP/
ss0prayaz+F/pe+oQ3HCy/ASPHH3Zc1uweqI2OYvHBjfsHz4jmA8dfQJMhQGcBAS
qQizxpj79HeDwXNP507BSh4SQ4PNT4/w0h9Yn+KZLzWV+Q7Q9EspZJHeGOGy0Ya7
NrRpOl32VBcY1Okpl6wpmXSC3nOCfxtx7JJXLFjpC0a5dfhZRJ3qPyNypX4kGNuH
PvLA9+LEA7Ruk+tuzi/7GGi+RN3WubX1BVg01VnIXeXECB420c4i88kuPoPQIeQs
7zJLtKPjBXxsXKzwmrsbwKXwr21q+2sKyjeRleRnzsWglFvsnzjPnMgpSZpT9nML
viTOcqESbnk1jtzpwwYevaRxq7kmvCD7tOWuKtyKLS+uXsD3IJ45wfASI7XHMKdu
srnozYxotNJH5d0EfQdV7qu6pqUQBJnD+FfGhK7/AuaqQFcpBfaJqFMQe9sefwoz
wf6pikm2I+EUKfBNa3KgRU83MQJlB8DFD9shdCuDXWxW8xNJP7foExYpE5d1h1eP
2H24j1f9oI3oE/51VARF2q5EQqv+NwKFxys+YUpyVxd2UAwxeKS54IJlgMam0Dob
eb9czv/+Kbyb3hL9gJNT
=xTLd
-----END PGP SIGNATURE-----

--=-5rBa0Uh84xBaB08JBrI6--

