Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbYF3LHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:07:06 -0400
Subject: Re: [PATCH] Add module parameter to override regioncode on libertas
From: Johannes Berg <johannes@sipsolutions.net>
To: Johan Adolfsson <Johan.Adolfsson@axis.com>
Cc: linux-wireless@vger.kernel.org, 'Dan Williams' <dcbw@redhat.com>
In-Reply-To: <054201c8da7b$b12677e0$0137550a@se.axis.com> (sfid-20080630_083743_406500_6D839396)
References: <054201c8da7b$b12677e0$0137550a@se.axis.com>
	 (sfid-20080630_083743_406500_6D839396)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R7TO2KnY7zMDS/cg1H8K"
Date: Mon, 30 Jun 2008 13:05:15 +0200
Message-Id: <1214823915.5507.32.camel@johannes.berg> (sfid-20080630_130710_189122_EB19FEDF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R7TO2KnY7zMDS/cg1H8K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-30 at 08:36 +0200, Johan Adolfsson wrote:
> Resending to linux-wireless after positive feedback on libertas-dev.
>=20
> Attached is a patch against the 2.6.25 driver that adds a=20
> module parameter called "regioncode" to set the region code
> in the libertas driver.
>=20
> Hope the format is ok.
> Signed-off-by: Johan.Adolfsson@axis.com

I wonder if libertas could start using cfg80211 for this? Just register
a wiphy and use the enabled channels there?

johannes

--=-R7TO2KnY7zMDS/cg1H8K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaL3oAAoJEKVg1VMiehFYmGIP/2kuQJo1wQ8tJurFEhrh9MnO
ChvzQuGQ0ygVbaxJKc/eIAt8g4QBRybtn6h80YkBuzGHKw22EnLDg4wHYNtznH1+
8ltzL6KWbvJ61SX0tgvGD0DS+1ncBJibCDFRMGCA3L6+oRp8H9t7sJCfPn0eevk5
aQp6EFdoNe3zOK8ZPVgYPkIHfJ+v7qZ5EVQzw2gUJHn72rRWMfqHee17hPaafc4/
0rA5U/7ZUbSHBvyMJ9mSIupHZyVoFLGlxsN226OglMOuFkN7BEHISJL87hqbhot9
Z0XNaH0CB7H36oCw57wmfCGLwkq+Iia+TiRu638+ay8KcJQWmyidmLkpSVOYkniA
Mt7KrMk+4DiSzHd4Q92/jIcOubCRe8exz1xUyosAS0K5KD2vqtb4rikE1GKJq7cn
3fv6jFrHQV6U57BoEcwd+4+TWoEXg3duc/yFZKmsFUP6bnaXfg6xEKS4W9A9YmLV
/QubhWc4l2ON7TvPWuaJYsq27dcN9wkgJJxpyZKBq3kx/4bAvJXbqRq6lsg0sAHC
YFVxAtFKWDgU0/rNynr01yaIB/y+oPePHrygy90KxxMLa37jnDNjj/5Zrs3O/tsq
XRwrWFWuTT+lmzdewOIH0V18a/kX07LuSfdCC9wIxlHN+fmWNVVaL59tD6w2qttO
HOvMRubU3cWe5KGnSrYU
=6IJs
-----END PGP SIGNATURE-----

--=-R7TO2KnY7zMDS/cg1H8K--

