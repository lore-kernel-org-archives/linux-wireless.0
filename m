Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbYLKOM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 09:12:57 -0500
Subject: Re: Listing established mesh connections
From: Johannes Berg <johannes@sipsolutions.net>
To: Keir <keirlawson@gmail.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1229003711.8081.4.camel@johannes.berg> (sfid-20081211_145557_042440_476C99E2)
References: <e27b78a40812100713l588e5cfch952c3d909c1dea19@mail.gmail.com>
	 <1228922932.15837.4.camel@johannes.berg>
	 <e27b78a40812110314w409a0294w1e73d40d9d34fac5@mail.gmail.com>
	 (sfid-20081211_121449_680610_19E5F8A5)  <1229003711.8081.4.camel@johannes.berg>
	 (sfid-20081211_145557_042440_476C99E2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DhVIosaiSCqI4p44LY7v"
Date: Thu, 11 Dec 2008 15:12:17 +0100
Message-Id: <1229004737.8081.7.camel@johannes.berg> (sfid-20081211_151302_562485_47B771EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DhVIosaiSCqI4p44LY7v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 14:55 +0100, Johannes Berg wrote:
> [dropping o11s list, keeps telling me it drops my mail]
>=20
> On Thu, 2008-12-11 at 11:14 +0000, Keir wrote:
> > Hi,
> >=20
> > No, I mean I want to do this within the C code of the mesh stack.
>=20
> Oh. Well, is that what you want? If it is, then you can iterate the
> sta_info list in the stack and check the sdata.

I mean, if that command prints what you want then you can easily
reproduce the same list in the kernel.

johannes

--=-DhVIosaiSCqI4p44LY7v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQR+9AAoJEKVg1VMiehFYArcP/i2TVHOcrPCo3d5syY712al8
QGwxBqGnwsis7oBXydEIbZh6yK/YXZ8mTFTIezah7bi9ji88HEgmOR79VRScKDcU
1Hiz2RschowBsX+buWE9VWhPmmVbaxQDJa3BTOSY9lIj6VMD6beiEPRFQ+oZULeS
2Hiw8bbQhG/mnd6eOi8rXUsEZpKPE5rmQF7knVb1v8aCXNaxQ/wOvJr8HJ5wgLJn
Bh7wHzS8kjO/YwelnDx7kKjWDlCyhBdLmW6CoPbqhlewLOK/qdMLqhRO6dQI0WrH
GAEVlH8FuUylRuSzudfPOpkdHYaFHKheLZW0HVI7LiIALw8glXyrRgWpWoJE+8v9
1DuQvx1gXWCMKHMgybn/EtJByskzx8eo6JvyRhX/eTRA8xsfGmDJsgRC3O1wFPCS
DRq32vgqV3mqDwk9aOii8F1FlQiLOY8qHKoyuQ/IG5er/SxBt9ohMHZMvopt/ZmM
XofQejZ9DAyx7jw34e83k4leEyKtQ3pERHrCUMkQYA4PDQBQtOcYu7rPLbg7jORQ
s159oXupZa/aDTemcl86O/k0Bo/CKKEcKCsYdXGBs0TlG5VUmcd+z0rGeiZTkalt
5rid3B3GENNQFOKtd1ommPS9tWXs5jJsc87VFHUdTjPBKY/GkA66sz9fP3sZO3Er
xHRSVPS2JjadaBYNgDCL
=BMTE
-----END PGP SIGNATURE-----

--=-DhVIosaiSCqI4p44LY7v--

