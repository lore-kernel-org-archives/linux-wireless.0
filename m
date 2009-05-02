Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbZEBVQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 17:16:20 -0400
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Alf <alf@mypals.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241298894.13562.28.camel@johannes.local>
References: <200905021218.23747.alf@mypals.org>
	 <1241298894.13562.28.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jIAW6SZc1UFvG24qxoZY"
Date: Sat, 02 May 2009 23:16:18 +0200
Message-Id: <1241298978.13562.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jIAW6SZc1UFvG24qxoZY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-02 at 23:14 +0200, Johannes Berg wrote:
> On Sat, 2009-05-02 at 12:18 -0600, Alf wrote:
>=20
> > It seems I am able to associate with an AP (not just my AP) sporadicall=
y. =20
> > It seems that when it works, it works reliably, but that's only 10% of =
the=20
> > time, if that.  I have turned on debugging on ath5 and on mac80211 but =
the=20
> > debug messages don't offer anything useful.  The only thing I get is th=
is:
> >=20
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
> > May  2 12:08:28 wlan0 direct probe responded
>=20
> What kernel are you using?

Sorry, never mind. Shouldn't reply to email after have a bottle of wine
or so ;)

Sounds like your AP isn't responding -- can you try to move closer for a
start?

johannes

--=-jIAW6SZc1UFvG24qxoZY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/LgfAAoJEKVg1VMiehFYlzoQAIJU/ipzqRgKq/oMpVcVY+X2
L/UClpYdn6BQww6TSLt7oR2dlpSk750Yhw3Auimg0RkgBSL2rGJ+HSfSSTRHEfZ2
0kK3CxAXAZRoBr4SqDd0/dh6JzrToc6tc2LnmFA5a7ASgmyCB6uog3qNj7Mh/8S6
lVcdzh6xB7/Bwj3Y3jEP0gVocQg3ZvZjszyvYocmWxYfiOgPrdlR7GqofSUF6yoc
pv5KA06v9dVCpm5jztlpr9SVskiMw3f2L/Xw1D5/aaomVLwIh3wsgt2czzwgETDN
rJwAQwEbtGEACOSiTuWFUqXiqxKQ2l7Hs0/tQHsE48GK0jo9stEScx+v/JP24yX/
xvGXDS6MKyHg6EP+VSyvOT4hYcuHgOkhIO7so8VisAdRvQygGP7u0NB4dOdiqnh+
RvfqzAzwjmm3yn0rrzI0wFFIy/kvWzVbZNR0v3cg92UVI+dpPFjYt9u4CXjey8kJ
fi7NnXS0sGOQPqXTHyZT1RyOT4kswe10s4BI3vW1pdkYeuvKrjxD7pmgsLpn5pFq
15fwvhJOpFNUeyZ6wfvBHzqSa0EqEzlw+ym/WA7vcOibS6nz1od6xH+/LwRRAh5c
jYS0oAw4wyo2hrjSPv7ofHrlfg3TNfTWbu98L3KCP4r1IVuCjh047KS5Nin2vWoN
2zK9ZHz6PrXXn3Wwx+G4
=wDOB
-----END PGP SIGNATURE-----

--=-jIAW6SZc1UFvG24qxoZY--

