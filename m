Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44193 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbbE0XaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 19:30:25 -0400
Message-ID: <1432769411.6319.36.camel@decadent.org.uk> (sfid-20150528_013028_889444_B6978F77)
Subject: Re: [PATCH] mac80211: fix kernel-doc comments in mac80211.h
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: andrey.konovalov@linaro.org, emmanuel.grumbach@intel.com,
	linux-wireless@vger.kernel.org
Date: Thu, 28 May 2015 00:30:11 +0100
In-Reply-To: <1432127031.19214.9.camel@sipsolutions.net>
References: <555a4e12.e323700a.26a6.ffff9e65@mx.google.com>
	 (sfid-20150518_223947_537367_CC6BC263) <1432127031.19214.9.camel@sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TN0HPgK+Hcy+zNKrVyqR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TN0HPgK+Hcy+zNKrVyqR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-20 at 15:03 +0200, Johannes Berg wrote:
> On Mon, 2015-05-18 at 23:39 +0300, andrey.konovalov@linaro.org wrote:
> > Commits a818292 "mac80211: convert rssi_callback() to event_callback()"
> > and a940909 "mac80211: notify the driver about authentication status"
> > added two errors and one warning when building docs for the mac80211
> > driver. Fix the kernel-doc comments so that the documentation targets
> > could be built successfully again.
>=20
> This was already fixed.

It's been one week and this is still broken in Linus's tree.  There was
a fix for some of the other warnings, but I don't see these errors fixed
anywhere.

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-TN0HPgK+Hcy+zNKrVyqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVWZTiOe/yOyVhhEJAQqrGRAApTkHaeievT86SCa4VGfH9nl3H+FlqvXk
So8miWu1ynzggps1mjEfr++ZTsJESHcIPe9SygeKWj4JgdF0CRhwkakBj1xjP3lV
GEs54+wNtrAgN5iN8eNaziLy4Oiisu3wldO47J/Puiu6FbbdCNFg/CL/iCGy5tzR
f8h722I8+Q36sFyErc29Vqk1xuShomjiEanbVmudBBOj3qbNbR8+7Wi4xzuOM4J9
KpuhOGUTa/BbvBfr2QHIjZLeKmrygUUkoqlr6lL2Gpvvb2YESjyQZKtxOJFAWwXr
v7EgIkEkeBXahERqh9IqgT0FlCYKa5eWcmVETq9iYrcrO2B4JXzUDgVkcKF5rpO+
aORZyaqz+t2EEs4aYXXWhmB4WuArXDq8PTM5umcOcpEzViTLox+OhKvpza2y94Fk
CZ+dXWVJ6+LvwIEAdACc6K4U6O1yejqfx9KQZbrOcZJ49Qc+HoBSaqA6CT7prgdI
3Yowy0R6FonwRm1TgCsMnFQ2WoZYnWJrD2u8CkA7KUSS/9gHxGVmch3rhGziEvoM
ziYcp8+YKJi8wWM2PJZYEsiJWjHjBBniOo3XCw2DIBz/efoeyo1zl6Z38PNGpSOY
NjMvVK2s5R1hD1A9a5ctnnv0TNC4iQhsWYoLhiaV8eIOeHNfWXjBXZCQmzF/zye8
3WEmu9nuYe8=
=MiWE
-----END PGP SIGNATURE-----

--=-TN0HPgK+Hcy+zNKrVyqR--
