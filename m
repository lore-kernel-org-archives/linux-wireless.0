Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbYIOPyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:54:33 -0400
Subject: Re: [PATCH 2/2] Don't destroy authentication algorithm before
	authenticating.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48CE8452.9080604@odi.ch> (sfid-20080915_175050_484202_3CD78757)
References: <48CE8452.9080604@odi.ch> (sfid-20080915_175050_484202_3CD78757)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UlBt+yoUEUTtv0dynL85"
Date: Mon, 15 Sep 2008 17:53:59 +0200
Message-Id: <1221494039.3700.47.camel@johannes.berg> (sfid-20080915_175436_628701_2C6083E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UlBt+yoUEUTtv0dynL85
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 17:50 +0200, Ortwin Gl=C3=BCck wrote:
> reset_auth is called before each authentication try. So it should not des=
troy
> the auth_alg that was set before.
>=20
> NB: this may have side-effects with automatic algorithm selection if AP r=
esponds=20
> with alg not supported.

This seems entirely wrong.

Is your AP not capable of/configured to do open auth and _also_ doesn't
reject the attempt? That is, the AP is just completely broken?

johannes

--=-UlBt+yoUEUTtv0dynL85
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzoUTAAoJEKVg1VMiehFYrB8QAIQFwA6l/0i3COq4zjz8fZOU
ELmg9QueoukgGyl9ohTorMo9byFBUpeXVatulBe3Hz9LzsuGYsQ3oU2SjEob42AB
IPMEFGWzQHuM3PEG7MMeY4xntaDY8HUBXw3eAWzx+wcmy7Re0K0KJ8zPOvHw+Zpc
tdRmH/Nn6UcOruuO0OWZTgAlXASjlFhbwEjv/ki3bBlUxinrTb5DqYoKMqxHm4YR
BmlbGVwkFpJq9ASCt2jURUDykrlbKEpM0L0qW/6tCwhb464D99zrkWjILE/cPJLc
dyb9yuupEOTz3YTWJn9O/ezJL/X8YDqslBnbTN9Gbx8otSE7SjSn0uRd7PyasTqP
8G8Lx1NsmwP76kQP2TtM6obNyD8pjMOXHmokJnr0fOZZe9Zyt6dZPbuu5YHomQE/
DuxpLEbsnX7QJzjTq6eqwF+oX+Rt0NlVGg0U46k9Yq0bnE79E/LLPWcO1bCTzIO1
PM3xcsh5nNBmaFMGb5othEZC1Z/tQi7GtsvWWqeqCGDS8LzFhWikmDQ425pT2ryh
0PWpwic5lMw0ixraC+OV7GawM7rJRPdvE5bJAtzW6mlT738AlzIrkWT1sEGEzNd1
1GkczIjOYoV+x2mKUrYovoRmsYXlrol2K96bdw9WfFcefZQ6kFF2IV4iaN8AdWGA
vSa4OXV3KFHOAxNnQ5Yn
=Dbzg
-----END PGP SIGNATURE-----

--=-UlBt+yoUEUTtv0dynL85--

