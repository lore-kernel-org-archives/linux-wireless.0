Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbZLALY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 06:24:57 -0500
Subject: Re: python nl80211 code
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87638r6l4i.fsf@purkki.valot.fi>
References: <87hbsb6pot.fsf@purkki.valot.fi>
	 <1259659425.32171.54.camel@johannes.local> <87638r6l4i.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vF8pHK3dKQ4+/KqRh7FR"
Date: Tue, 01 Dec 2009 12:24:59 +0100
Message-ID: <1259666699.32171.72.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vF8pHK3dKQ4+/KqRh7FR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-01 at 12:31 +0200, Kalle Valo wrote:

> Thanks. This looks interesting but doesn't compile right now:
>=20
> $ make
> Checking netlink numbers:
> check.r5cOZHc/check.c: In function 'main':
> check.r5cOZHc/check.c:63: error: lvalue required as left operand of
> assignment
> check.r5cOZHc/check.c:78: error: 'NL80211_CHAN_MAX' undeclared (first
> use in this function)
> check.r5cOZHc/check.c:78: error: (Each undeclared identifier is
> reported only once
> check.r5cOZHc/check.c:78: error: for each function it appears in.)
> check.r5cOZHc/check.c:80: error: lvalue required as left operand of
> assignment
> check.r5cOZHc/check.c:86: error: 'NL80211_RATE_MAX' undeclared (first
> use in this function)
> [...]
>=20
> The parsing of nl80211 seems to fail. If I find some time, I try to
> look at it.

Oh, that's not surprising, it's over two years old and after I started
writing the C tool (iw) I never maintained the comments in nl80211.h
that this tried to parse.

johannes

--=-vF8pHK3dKQ4+/KqRh7FR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFP0HAAoJEODzc/N7+Qman2YP/Rk5+IZEXDgw2O2XO+nVqdUW
3bPKbsIEqZk0pruOhEYQercxEwqeP4FaXmwV+IKSczwem2/ANhkvOzHaLHcuT++R
UrXBjWRMM+M8MF98RsyYntaaEblkQBKCUO5IZ3/KLNGMA8PwmwKfqFGp8hSWavFn
u9VNx52gbZmkY1j+36M9HaOJgFeQ4z1Ss/t47mo9Hlb06Uy9IugSU0s+97tGN/fB
CTtSKYkbLpdThFJvudUAvj5BUajqxJhjEfgkQHIhkSg1ln7fcK839YEK06eRXAPw
MvKxi1t4nMV2pNyBQ8Te2CO0pKGmLcNfxuPlevowZjevIOIC3mgYQwyBrnG+yRmB
NbYZWAieSWuqGBDpYNiUEE9GRnjp/RRTSASxZH/kJayU/RkOZauObBLZEmZxOuWb
skwzWKPlchvg7u7odwyVaqmvYitNyo7BAwnZOsv00t0fDv7K32p3jhxzshGt/t25
1GxSKde7Pqlp0SQgpFcYEbuZBxPSBtMzRIU8X4iM8BmgGJ5jRSl2Ak8EvFGjJ1yk
v7JAbmCviaNGOPf5O2c6IeRi5TIVY6ib4+naGgyssG7GzUxV7njFZMDYLW1fSj2y
x3pfumDqgtq4Yk4r3ZNVEy3q7Tmz4vA0ooW/b290cIf96A/lymiJxGEvv7chwODX
UWC7+wfFtvluHRcrb/yo
=OA2z
-----END PGP SIGNATURE-----

--=-vF8pHK3dKQ4+/KqRh7FR--

