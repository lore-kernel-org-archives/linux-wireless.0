Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYCBP3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 10:29:05 -0500
Subject: Re: [PATCH] p54: fix eeprom parser length sanity checks
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Christian Lamparter <chunkeey@web.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200803021618.14123.florian.fainelli@telecomint.eu>
References: <1204324105.3938.49.camel@johannes.berg>
	 <200803021618.14123.florian.fainelli@telecomint.eu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FjjekAM1B+lCZFMGQ+gU"
Date: Sun, 02 Mar 2008 16:28:51 +0100
Message-Id: <1204471731.3917.22.camel@johannes.berg> (sfid-20080302_152915_004051_96BF2D5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FjjekAM1B+lCZFMGQ+gU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > When I called p54_parse_eeprom() on a hand-coded structure
> > I managed to make a small mistake with wrap->len which caused
> > a segfault a few lines down when trying to read entry->len.
> > This patch changes the validation code to avoid such problems.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> I confirm this patch works, thanks Johannes. Tested with an Inventel UR05=
4g=20
> dongle.
>=20
> Tested-by: Florian Fainelli <florian.fainelli@telecomint.eu>

Great, thanks for testing.

John, please merge both these patches.

johannes

--=-FjjekAM1B+lCZFMGQ+gU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8rHsqVg1VMiehFYAQLVXw//To9+H8fIBkGroCbH6IeKg8T91AufYlv8
BFqzBchRPsdp9kF+btcQp/G/EkuIZlYFpdgFOpDXFTsr9tnSAHI6+xfsFfWVTRkB
b8jVPN7ULLER07Sp6DELyLXTbwdBQ2aehHxtU7CukFOxW9o86LNQBcwXiAP9XQ/K
r6/OTPmYkIJDIj55bXQivMAv1evxD5dUsM+SIOSwDH5pyxHvF3Ik83Ul4yDyhR0R
OYC0Za17gr4RdHgcJWyQgGCCeKWdGa2n5n790U2mNZOkl4AhJ/BAGXDlBcgdTD1F
4fJvkJDKmDyUZwDnjH1dt+M4PZZtZlEVwnURH8ygZJ5s7tsC5A23ztpPvKNjESpI
561zUkU9zrkW+MrjjALWe9R11RrrgaXU8VvJnCDW0Vr35qQAy2rmAZyoeK+tD5y/
CF83fBzisNRDQa5lQ82OYWR7o6ZaU5EI+x8g6zC0k92+wMycTDhyBFsrrPcTsQRj
sFVzpZFGk/cXe1Vx5t4XEJNZNZM5pqDbvmos55o5htM12196lzsRSrJbC/ogcsSM
J8IFQOEx4VqoI73Y8gzNbesK0cjT2ZWp0Mk1NFn9CNlH439nIeINpYpPHMxmfdXY
ALium+MdjCOb+QNzVdL/yZeybs+dwxliaNtcqbNojxL0nCn0eiqk1psVeVNyQDJy
mPFF1quzVhs=
=fpAR
-----END PGP SIGNATURE-----

--=-FjjekAM1B+lCZFMGQ+gU--

