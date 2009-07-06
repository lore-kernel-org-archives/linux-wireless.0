Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZGFRMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 13:12:15 -0400
Subject: Re: rt73 in AP mode: PS frames buffered but missing TIM bit?
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050907061006k3bed082fg3428a50370b0889b@mail.gmail.com>
References: <f76a32050907061006k3bed082fg3428a50370b0889b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HCYE/PBTj5MPWH9cDp+b"
Date: Mon, 06 Jul 2009 19:12:17 +0200
Message-Id: <1246900337.20908.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HCYE/PBTj5MPWH9cDp+b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-06 at 19:06 +0200, Stefan Steuerwald wrote:
> Dear wireless wizards,
>=20
> I'd like to ask your help, please.
> Summary:
> - I suspect a missing TIM bit when using rt73 in AP mode with my
> powersaving iPod Touch.
> - Despite frames being buffered no TIM bit is getting set (I thought
> it should), station stays asleep.

Sounds like a driver problem, it must not be reacting to set_tim()
properly.

johannes

--=-HCYE/PBTj5MPWH9cDp+b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUjBtAAoJEODzc/N7+QmaE0YP/2cPzizH5+r60dEupyPFFiKF
sdUckAoDQ0jmuCUKkrKyMB09nfQ89ANo2kGQ+nqDCkCJaXkiMyDtbzNdFZbk8xtv
FB4kNSRJAb0RNdL6WUhVrmQyQGwayzB0IwHiQa0gn8TQPrWWII1FiZC0jvU11u64
j36KEWr+t1R2SMgAzHTLyRZqLa5xS5KdaKaqu1x/4ueZEEfsaE+3KYpTjVgDAzv4
NS8FJA189Ekwq+pyfsHGnYn7bkTibbUgiOoYcpGBev6CsFFaCI0SNnd6FplMo3EW
RP5YJOhCMwquFlBuBxuwnJ6ZkvF0rG0sdwLnUpPoGfgM8oV7HNQZHMuhHaQ3X9dt
VxjWk5h+Cx8FHeVLBFprHuvSEImTLLxmkQNriMZg6A0liEd0LtArKR7tk8JLf1EM
7QGltbf9+qT18PfXivUq9ZsgA2NekP7gnWnTuykUvydMppGLXcwBro1bhk6snUxE
zQH48nluylApoBcZcfFjI2st7qDV531mXu10xpdDWk8J5Rm63BSrcqMh9Z2Qoxsr
vUqWiHNqtzyzJXlRAybdVg3gvZ9O18myQd5l7c+g6Va/b400R1827ah7yBYmPvOK
18AfTd1VprUMQ4iKuWdO93eO1H71iIa7ffWq8AzLIX5jkbfS/kRpGDozpITGa0tQ
sJRdmFb9hU74pMkwf3tB
=jAJZ
-----END PGP SIGNATURE-----

--=-HCYE/PBTj5MPWH9cDp+b--

