Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbZEDQKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:10:38 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gMQAfS4EwTeD+ehWEaC6"
Date: Mon, 04 May 2009 18:10:08 +0200
Message-Id: <1241453408.8683.53.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gMQAfS4EwTeD+ehWEaC6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 09:06 -0700, Marcel Holtmann wrote:
> =20
> +static void print_powerconstraint(const uint8_t type, uint8_t len, const=
 uint8_t *data)
> +{
> +	printf(" %d db\n", data[0]);

s/db/dB/ -- fixed, applied and pushed, thanks.

johannes

--=-gMQAfS4EwTeD+ehWEaC6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/xNdAAoJEKVg1VMiehFY9BUP/2N6rJGF52/TJ9DXXZWiPspg
12ETDPj/iFOKoxCzYRmh+Nu9F5wXymWzHGhbH56D2iQr5NmRYCtOYrJgQqpgGVg+
ghsD94lrAkZl3cQX3YfMqvWQqILtyLWQrseOHHYvPJdCkCQVxABAgw2B+iayJYJ9
KdmmTGTec2DgsMpBvK8cSozZlhWyec4GNhoWZR0b636pmJEqwPxJNCo8HRWkvw9x
EzO1BbkflVtpfgKUePXyeeqWIw3k2he1d8lmN3irnW0YLLhynsd1BENAyzlfbOIK
ZuMRDUQY4Vj05mmEAjicZb9W/WBK6WEf6dnVFLoKDrdUPaY+KEjUkpc0XTXjgN9m
6LQmVzudWNMIaZ+WKurZhAeCzK+7EDzlb0IVzJEyPGakkGsa91HaOqTigDDzv84t
nwPGnVM3+A2yzR1NvyrWV/3vWiEGPiKuXFGgcgR0ajTy3y3j35l2h1qFd8eKmKY6
IICyRaIcNrihu0CnWcFqBSkBBD9YFikCxxci536KhLeO3oLvAPaWifzT65dP0P69
AijcQxKlTAQPNjWyhLVlxJYDyyhn6ph3t8D/FYIK5T9mw7SdIi8SEOvEkLUHbm91
03Tu0tDeqXCq+PFPEN9DFL3FV3Ay4+PMsqzFzuX6c7lROHBDeKrYKrPCod0EU0Sv
KEuZtTqleI4X1asMyyLZ
=THqY
-----END PGP SIGNATURE-----

--=-gMQAfS4EwTeD+ehWEaC6--

