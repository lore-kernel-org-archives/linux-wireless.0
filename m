Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbXJQIOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 04:14:24 -0400
Subject: Re: [PATCH] mac80211: make ieee802_11_parse_elems return void
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1192588723322-git-send-email-linville@tuxdriver.com> (sfid-20071017_040850_773374_BBDC8119)
References: 11922218622135-git-send-email-linville@tuxdriver.com  <1192588723322-git-send-email-linville@tuxdriver.com>
	 (sfid-20071017_040850_773374_BBDC8119)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yMbkF8SpzAEoYNHyCl6S"
Date: Wed, 17 Oct 2007 10:15:11 +0200
Message-Id: <1192608911.8841.6.camel@johannes.berg> (sfid-20071017_091428_168925_21EA98BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yMbkF8SpzAEoYNHyCl6S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-16 at 22:38 -0400, John W. Linville wrote:

Looks good to me, but

> -	/* Do not trigger error if left =3D=3D 1 as Apple Airport base stations
> -	 * send AssocResps that are one spurious byte too long. */
> -
> -	return unknown ? ParseUnknown : ParseOK;
> +	return;

huh?

johannes

--=-yMbkF8SpzAEoYNHyCl6S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxXEjqVg1VMiehFYAQIGChAAwsbwgFM3wKzpESrpq00fZcE+2xji7c78
Kosswgkrh8BDX9/Tvexv0IUrDJYAKi695tCbZejdCcTC/sQD5GJV8J/mYqz/wGB6
bLbOVbgniwd3wsE9qRDfN+MnUvbgiImc3jBwZ+PYWeauVRFpm7WrUR0SI6Jq9crA
0NMtYaWW0UwGxZA3lDLdyfCFXj1JMpWT4MV4L/BMctX/Xy7tyxnl4KuuYLevMRHD
kId0PfUjPuLO/sqIYNwa2KHxVX4ANWZod48OGYzSOELC6jvWQCVKuzGhcvVNfLtd
WGx1f1JXqVeIktyMeVaFRIjM2EUkmgs080pXoq9DoIUXtJxwxxTQp4kzNzHOXJ+w
JVEgRpp9Yl6iPWhY8+3SxotQVS4SbuCElTke9BTfMXzlj0sGn/MNp5kZaWS+hraC
MMbXbwNS/16g3OiencS3iSs0xUJU4iNB3ZoDJ4YKHhAupCFxrhq9Eqgb0jwZsM+e
nsanPQoX//8NbApoW1N898XepvALXZWsu/Uc3ShWpzNJTk95ZJyvUIjizRvpk8w/
0Nz9jDTvPq/g+bDHKWbQnwvnkmsza7vlzLygED/174v519yKx1ZEogkPoffLYTdA
qD+kXcZJ57qevWJT1Rq4pnTrvT0A/mIcfwyAzAoUN5KlT9Ktr3VhLzzHvdiUThsS
IgAkqTUk4GA=
=3Kdg
-----END PGP SIGNATURE-----

--=-yMbkF8SpzAEoYNHyCl6S--

