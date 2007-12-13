Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXLMMxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 07:53:24 -0500
Subject: Re: [PATCH] try 2: mac80211: Fix swapped parameters to
	ieee80211_set_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20071213125047.GD501@lunn.ch>
References: <20071212153158.GB16947@lunn.ch>
	 <1197481426.6558.138.camel@johannes.berg> <20071212180204.GP31218@lunn.ch>
	 <1197482969.6558.149.camel@johannes.berg>
	 <1197504975.6558.199.camel@johannes.berg> <20071213120904.GB501@lunn.ch>
	 <1197549025.6558.253.camel@johannes.berg>  <20071213125047.GD501@lunn.ch>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rSlMgn61TlJwya098ryx"
Date: Thu, 13 Dec 2007 13:53:18 +0100
Message-Id: <1197550398.6558.257.camel@johannes.berg> (sfid-20071213_125326_376100_4453C5B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rSlMgn61TlJwya098ryx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> However this description does not match the implementation. The
> implementation is that its a channel if e =3D 0. My "frequency" is > 1000=
, =20
> but it was still interpreted as a channel. Looking at the
> implementation of iw_float2freq(), the description should be that a
> value less than 1e9 is a channel.=20
>=20
> So there should really be a check in the user space tools which says
> that values between 1000 and 1e9 are invalid. This would catch errors
> like the one i made for both 2.4GHz and 5GHz.

Yeah, well, we all know wext sucks. You are of course right, but I think
that nobody's motivated any more to fix things.

johannes

--=-rSlMgn61TlJwya098ryx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ErPaVg1VMiehFYAQInWhAAs6tSdbrbSKoKVEBoroG05lUgMUOvcUj8
YnxYyLyHWC2tJNYZJNKtz9s346xFxPlKOUKjqCqQwyCO1xeOfcNK3GJ3Qc4oGH5f
uDC0xzg/fjuP/suhA+Uj9N7y/JOK51e7LuZ+fGqpqXkKKTjybfY+kEXQF3IjtVGd
0/ZoUbRMk19GB0hWqOIbNk3nHGeARlDuYzzU2Rp2SA+qiIjIZjw//GPPzYUpwm4q
oOqtr6gu/HbRuLQw7UkMrmq0N90vZDAsjQOPClwze7fcoo34MdM4cjKnqblJAyEn
PGJKnMcLzNrD9vWYuBnC5w0wgQbZljp4dNBjvtEZLe9gN1xgaZIXKfWUCBX0PJb5
lhaw4uqcFXUE3sXM9+MbCh66vfwc1TNx4ky+alyVVAXYf6Itiiya/3u5I4+b1e8M
u8DDfw838LJ0anI5wqDUA1TXJu4woqRdaVC2bdsJwlacFHJ6SqSbwHyZ5QKqP7IR
SJrNC3LEamAor8rFoVhXDBgQNUqkLyjNlOSjnGCdnLxnv3Ar4MNrXXBWIEVGRbu+
VzrAIKtLwg/ceq4qWY9pe+bIMZkvCaMADsb8O9dPPLylKctDqUS86YUKSLUsOCzF
zt/jeI2sG0iXpKQiVTzj593SZ42qjjRtp/5sZShY8RPmqmsUeUjazXJj0sVvIvS5
4rR5IG9Cv8Y=
=dGA+
-----END PGP SIGNATURE-----

--=-rSlMgn61TlJwya098ryx--

