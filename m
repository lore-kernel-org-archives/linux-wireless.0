Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbYCEJfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:35:24 -0500
Subject: Re: mesh beaconing questions
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <445f43ac0803042137n6ce996f4radd58d3104fb49e1@mail.gmail.com> (sfid-20080305_053741_952259_3D63D0BF)
References: <1204034825.13162.233.camel@johannes.berg>
	 <445f43ac0803042137n6ce996f4radd58d3104fb49e1@mail.gmail.com>
	 (sfid-20080305_053741_952259_3D63D0BF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SNu7amnWD3RF7xbz4AYN"
Date: Wed, 05 Mar 2008 10:35:10 +0100
Message-Id: <1204709710.25502.44.camel@johannes.berg> (sfid-20080305_093529_601876_E835B36B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SNu7amnWD3RF7xbz4AYN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Javier,


> Beaconing and synchronization are the two areas that are still
> actively debated at TGs, and they are somewhat dependent (
> http://odysseus.ieee.org/cs.html?charset=3Diso-8859-1&url=3Dhttp%3A//ment=
or.ieee.org/802.11/public-file/07/11-07-2853-00-000s-functional-interdepend=
ences.ppt&qt=3Durl%3Amentor.ieee.org/802.11+||+jarkko+kneckt&col=3Dmentor&n=
=3D2&la=3Den
> ). I would not invest much time in trying to support both modes at
> this time.

Ok, thanks for the clarification. I'll see what documents show up :)

> That said, if things stay as they are now, we would have to make that
> configurable (only if the driver supports both beaconing modes, of
> course).

Ok.

> > (...)
> > Hence, I think the draft needs to be expanded to modify 11.1.2.2 to
> > explain under which circumstances an MP shall cancel its beacon if it
> > opts to use IBSS-like beaconing.
>=20
> Agreed.
>=20
> > I think the only useful thing is to require it to look at the mesh IEs,
>=20
> ... and path selection method and metric.

Good point.

> > but that is not implementable with existing hardware, at least not
> > without firmware changes.
>=20
> Needing firmware changes is a problem for o11s, but not for TGs:

True, but I think just like with o11s the adoption rate will be much
higher if it's easy to implement with existing hardware/firmware. Of
course, anybody who runs firmware can do the trivial firmware
modification for such a requirement.

> there will be other firmware (and maybe hardware) changes required to
> implement the standard.  o11s challenge is to do as much as possible
> with commodity hardware, and doing IBSS beaconing with null BSSID
> seems like an OK compromise.  Every once in a while and MP may cancel
> a beacon transmission because it receives a beacon from a different
> mesh:  that's not such a big deal.

Yeah, good point, it doesn't really matter too much.

> PS.  BTW, you should attend the IEEE meetings.  Really!

I have attended the London session (in 2007) but didn't find it worth
spending that much money on :)

johannes

--=-SNu7amnWD3RF7xbz4AYN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR85pTKVg1VMiehFYAQJlYw//QaRVhk2/MloTPqlv+NKXQ1Hr1INQWp2d
cOh5Yrrm0UqGt/SnIWdx/2wZRYceejgfj7eGiU/OeUZ458QpoVOsVq0lsS774HtC
pDba10A5D/765oo6BH0BHUb86ioa3mpoS1Nuo/6XL7EYl0QwzcuYH1Kt6ZjK+Jyl
ETmzSy6Lhl2xXhqFwbTmPnPZl4vXpeHGXVtVAFMYEe6CmzfeabGqoq3D2p5pR1YM
dbF/zfrZwodsYnGnl4IBDJ69kypxPq+8CUjeUk+OvyryybEOENz7tTGc8R9UXioW
GNPiuhqRvX6RpxLYHOVgyfUlUN1Is5TQFKz2jtsTrdy0v0vYKKgH+9X71G5zAbw0
Yxgv/nWOLX7IHAaPkTBtdZmNecmVYLN9TcfR9cqprDK7PPgE0v4gDHVcKvHACuQT
NwtDEbTQMOEj0apOpy4ytk7IWKy6JyEpPTjHpQVdceHafNr+MPLrkr0i0VhkMLYo
OaFplSHJ3gmXi7NwEjWDpt9HmmmIMk4UZ3ldheZk4SAKemOzF4y1ykoYSpxMs++a
r4ufXnjoK4Hi+KxHZ066jfq9rkdAlK3fAf6uQ98+efOdzCx0RR8ttNR8MmtjCDBU
ZfYjCw7l9diqtmQHzxIaU3ZBK7Kg4/KqBAz7DvJ4WU8yE8KEnppzuDLQV7TGqkkV
95it/yHF/jY=
=CPq0
-----END PGP SIGNATURE-----

--=-SNu7amnWD3RF7xbz4AYN--

