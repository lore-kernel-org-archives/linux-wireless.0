Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbZALPH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 10:07:27 -0500
Subject: Re: [RFC] nl80211: New command for adding extra IE(s) into
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090112150348.GA14029@jm.kir.nu>
References: <20090112122605.GB9153@jm.kir.nu>
	 <1231765724.2998.10.camel@home.berg> <20090112142646.GB12109@jm.kir.nu>
	 <1231771702.3591.2.camel@johannes>  <20090112150348.GA14029@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p1DjqTP4xRBT4dCZ3eg+"
Date: Mon, 12 Jan 2009 16:07:25 +0100
Message-Id: <1231772845.3591.4.camel@johannes> (sfid-20090112_160730_542286_A5903119)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p1DjqTP4xRBT4dCZ3eg+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-12 at 17:03 +0200, Jouni Malinen wrote:

> > Should we sanity-check the input? E.g. in nl80211, ensure that it's
> > (<type><len><data...>)* with <len> being correct and no final padding?
> > And maybe that there isn't anything in those IEs that we've already
> > added, like an SSID?
>=20
> [snip long explanation]

Ok, makes sense, let's leave it as-is then, we allow root to shoot
himself into the foot anyway.

johannes

--=-p1DjqTP4xRBT4dCZ3eg+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJa1yqAAoJEKVg1VMiehFYO5gP/0PkHeHJu1auVuLGA1JkrKJh
u9hZU58yXCwzuSkadrEtar0ddiR3XIEC1Pc9nR5v9lNNIz6hb0bKU+aRcWwWzdMh
aLkis8tbr0OMO5gtZLwvoNpTjhCAPtR3+8X0TGn1tnqOEEiuqkaf8BVE2G6fxqCv
4qit1Qxs41fQtUcEkqcgtclFa342YRqyZhWDD7MnoBgSRSM3eDThLZlDNbNJvqrr
1eDsJJXKJcswxAbM+0++4fZsenAO+/EQ+vav65hnfHfTbMQQAa6Vn0NQz6Ombek6
RzLMZ4kTSGFVk38b3/ffwjGFSb0N7N3glSw7Bu1dsnCMZ2cGeTzxIBb0WzAYsh4u
9moliXTLcU/LyX36dACiOmvdNuwW5E0V+qACvGgWS13vf5id4MAf4Gn6KPO9hv7I
wvNuV+RE/LzpdG0lyHbBWTkSUqSTwv+L1Oub3fWxN3AFciPxM6ZevMDauYueDupt
xCTiQYucHyvpQtDj2c5WswEwLgsDmlbs4jywSrGJckfQrX5+eaiYdKpqUqTFkg2e
ceZepD1HpXVvESkooXqhKvhNhnUNyXGpAf/X9AAls0oKUGwUqpejR6+ZEvNJAgC5
PyhfaEknoYstNvxVBGPjO6+lNj7t/MZR5bTprA/Y7fX42MjphDAeUKR3ldcOU5MP
ZpHMeWIk7K3NCktrmQNC
=+rQv
-----END PGP SIGNATURE-----

--=-p1DjqTP4xRBT4dCZ3eg+--

