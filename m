Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZEDShL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:37:11 -0400
Subject: Re: [PATCH] mac80211: report operating frequency rather than
 current
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905041133h1da905a5k1145496d7fdfbfa3@mail.gmail.com>
References: <1241452330.8683.49.camel@johannes.local>
	 <49FF2AE5.6040104@gmail.com>  <1241460130.8683.85.camel@johannes.local>
	 <49FF2FE8.8010004@gmail.com>  <1241460944.8683.92.camel@johannes.local>
	 <49FF3453.7020802@gmail.com>
	 <43e72e890905041133h1da905a5k1145496d7fdfbfa3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4y0pGFx5xHIC48ifRty6"
Date: Mon, 04 May 2009 20:36:41 +0200
Message-Id: <1241462201.8683.97.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4y0pGFx5xHIC48ifRty6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 11:33 -0700, Luis R. Rodriguez wrote:

> Why not show both through iw and for wext just use whatever wext did
> for most devices?

Where "most devices" counts as number of drivers (I think all
pre-mac80211 drivers behave like _after_ my patch), or number of
deployed devices (piles of Intel devices, I guess), or...?

Also keep in mind that for many devices we simply cannot provide the
real channel the radio is currently tuned to.

johannes

--=-4y0pGFx5xHIC48ifRty6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/zW2AAoJEKVg1VMiehFYqk4P/An1SxnVB+Y7Yx5amsMqzTPk
o5D42Uq2zOk3f9HGGlBqmGuE5Eh59ofcpexpzlOwEH2NNDg8JKn/U7+4DpMGGqe3
6nueEfoYR+1P0AKV3oXcr97U+d/6LvT3BKItgx2ZnijAIS72Sl0E9AhZqZc/MzBx
zMkokODPZtp7iTBE5o61u2lP4MyaAYj6dWjHJWaYNokc6+mS1ll/5Weg3/V2Cxyg
pLaEB1Qm8+9mM1iqxxTDdjNnwfcp7Oi9PA9ZTAWMILklRFX+/d3BWaXO4GQcXimS
PprjMwdL9tebPfA30LgZqGfUDtTxecsyk5fnLbYJzUttP1vjdpspY9WPdjDiWLpV
dE8xPpecAFexSDzkyW7EzktpTAVZ60YUEGpon5hEDNaFtb5PCjOJPrqZoFxmFo9R
aj4gK/gQJsvS8oljb9MpDGga4MJTNSO4c1mmOl4trrack59c/b/Fws0QMxgBYsE0
GdzGjjp2qgzKDA/RDyh9RLgQkudBnQB/NgoMk/m3GU3JDMxTUtllm+pJ+JitLZ3A
zFEN5z2EbEgROXqiD2DtJJkkeS3GwHIkPV+nQBBu4ZzyXgNJSBidx3hJ/Pl3CsXF
+XryMOPqcRNGoj6Au0JIpmIiPPg/ZtbiYrizNOWlvzECvJBMEyqwOQFofCvlbUMo
ICYHOHCG8/W+p4Aszlsc
=o+2L
-----END PGP SIGNATURE-----

--=-4y0pGFx5xHIC48ifRty6--

