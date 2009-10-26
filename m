Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbZJZMWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 08:22:13 -0400
Subject: Re: Questions about cfg80211's cfg80211_connect_params->crypto
 settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910261311.47164.hs4233@mail.mn-solutions.de>
References: <200910260947.48365.hs4233@mail.mn-solutions.de>
	 <1256548953.28230.19.camel@johannes.local>
	 <200910261311.47164.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EkYEIDFMzy2r5kEEoZb1"
Date: Mon, 26 Oct 2009 13:22:14 +0100
Message-ID: <1256559734.28230.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EkYEIDFMzy2r5kEEoZb1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 13:11 +0100, Holger Schurig wrote:

> inside .connect() if I check sme->crypto.cipher_suite for
>=20
>   WLAN_CIPHER_SUITE_WEP40
>   WLAN_CIPHER_SUITE_WEP104
>   WLAN_CIPHER_SUITE_TKIP
>   WLAN_CIPHER_SUITE_CCMP
>   0  (meaning no encryption/WEP obfuscation)

But why would you look at that? It sounds like you want sme->privacy to
know whether to select an AP that advertises privacy or not?

johannes

--=-EkYEIDFMzy2r5kEEoZb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5ZRyAAoJEODzc/N7+QmaruIQAKvHEGaFH15SKGTtK1CxrDLM
Bvy2C0lWmrp1wmaIpW2+HlqyHHCsMHGuDLR3xnpXejfHfMFgxZ/9loNMoxpBxjCV
M1i2FNiSOvrjT2HlhMELo7HltHa1ooqo/irqi0CE8o0p0VGSlAAw2OzckI7vXHGl
kgWRmvgWuX416qMinxS7ukhkCNyFLmDywSeojhLFkd9D7At5NaG7twYlIzved25f
bttCuzrrZt872UbhkV9lBixamAzXLAYuDYbqb2uUY8X8qUO/6bIV/kcjci3S8zfK
MNS9G5xrBPHjMWaudwwCeRYnq0v5zUo8+hLG8Uo/jOVUJ1wRhBo+REp5LwPoy3dt
9fhdzC0FkoxOd1Cml0v3QnTvyx/zii1dsdepNJa2dfKtLi70o/sYKppef6NcTGQi
myTWQGWsvYW5X12bNAVp3NXRnv9KL37yusdHiU8Ys0MikwUpYO2G4UHRvj6D1N24
/ff/p+v3dJV2MOTRRiOrMNDNBMnSxH6EM4zilqCxMGcIVV3pD4LoGPvKNVD/xuaW
3QY/lLRrRzvsKUuoEdoB7HB3pdAi8H/Rl2aUiDY9pCGln3bkXzE+f0E43vZP4sze
ni2WGjICyoZ7lmCBQcJ93cZSpGz0Ng/ckx6vIPO7W5jxosppqx4vUkEtoq0ROukD
X0A1mtJsXahaXC6CMfxO
=8YS3
-----END PGP SIGNATURE-----

--=-EkYEIDFMzy2r5kEEoZb1--

