Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0AXL3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 06:29:55 -0500
Subject: Re: [PATCH 4/5] mac80211: move control.hw_key assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <201001231622.03394.rossi.f@inwind.it>
References: <20100117004754.624627000@sipsolutions.net>
	 <20100117004825.177097479@sipsolutions.net>
	 <201001231622.03394.rossi.f@inwind.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gNw3wUPmhtnJFywlvjXX"
Date: Sun, 24 Jan 2010 12:29:51 +0100
Message-ID: <1264332591.23766.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gNw3wUPmhtnJFywlvjXX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 2010-01-23 at 16:22 +0100, Fabio Rossi wrote:

> this patch breaks my wireless connection. I'm able to authenticate and=20
> associate to my AP but I can't use the connection, a simple ping towards =
my AP=20
> doesn't work. I bisected the problem and your patch is the bad commit.
>=20
> I have the latest wireless-testing.git (v2.6.33-rc5-47285-g96ada3c). Afte=
r=20
> having removed all the commits related to this patch, i.e.
>=20
> - commit f12553ebe045a8a40ab33fa500fb57d10706e226
> - commit e4fca007b06165900d0e44e8d5e251376819bf5d
> - commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
>=20
> the connection is working again.

Hmm. Are you using hw crypto?

johannes

--=-gNw3wUPmhtnJFywlvjXX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXC8sAAoJEODzc/N7+QmaR6AP/2Z9gqQp0u4au5FoKr50ePMH
A60+fGDvHswa2KgVXqdG11jA4nKHZk8fTgSm7J1DvmTcu6ZxgPOkY84M/MKTwiG6
lmuP5u8JN8o7Heh80l8mCf7MrHJyy55QCxAKqgkK/0CJJdi466kH0my3HVzaIqYh
Uo2rX1+hnH6kzhywtU1gFxfJ6zGscgpT1ws8EBms8+MkxkjmqYuQTXHLCnO3NCM2
9BhVxPEezRHWehZCp3dXju8AdWwpiBY/mqHOLkE+DJxC6wJVDr3hlepbwdH2tL+E
FEjaZ/SUkVsOwVO/qCV1ul92TpxLn0ckK2BCtdeyqkOeTnVD4mifTBWEXsataeX9
d4dkMVKgu5xPdJnaLKqn3UZyi1z/gEy80UsdidgeG18rkfhBdeM52CrV4ueZE7uN
2kmkr4SiPCJkIAgy8Fk1Ur57cQbtbclCoHBAG28W5l/vEH7pqW1Un5jmbJ0gS6Bk
n9PozGeVRdxYOeThEdadpHz2VnSpr9q91y6GvNe2Cnb1vlFbC62t45x/yyKIuNvJ
4icIJ7r5hgVKm080zPgsN6LW+STYhje/jQZ7UvN/EAlISjFfmvdOInIQlL+5B+Qe
CRC7FoCOGt433A1hoIhTFP2KFzGM0rh8LP7AO+PxVJVwLMIwRT5pWxebldDl18aa
No9hPGQGEe6+30zMWqyI
=S8rF
-----END PGP SIGNATURE-----

--=-gNw3wUPmhtnJFywlvjXX--

