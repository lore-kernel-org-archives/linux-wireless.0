Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab0AMKTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 05:19:20 -0500
Subject: Re: [PATCH] cfg80211/mac80211: Add TX/RX commands for Action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, j@w1.fi
In-Reply-To: <20100113101126.GA12548@jm.kir.nu>
References: <20100113101126.GA12548@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9QlFVBmnZ7KPeCG6HCzq"
Date: Wed, 13 Jan 2010 11:19:11 +0100
Message-ID: <1263377951.5093.326.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9QlFVBmnZ7KPeCG6HCzq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-13 at 12:11 +0200, Jouni Malinen wrote:
> The new commands can be used to implement user space -controlled
> Action frame exchanges. These can be used either to exchange Action
> frames on the current operational channel (e.g., with the AP with
> which we are currently associated) or to exchange off-channel Public
> Action frames with the remain-on-channel command.
>=20
> This patch adds couple of to-do items to handle rejecting of unknown
> Action frames. This is required by IEEE 802.11, but we do not
> currently handle it in mac80211. To do this properly with optional
> user space control of some Action frame subtypes, a new mechanism will
> be needed to register user space handlers and to unregister these when
> the netlink socket is closed.

I'm not sure we should be adding this before we at least add the API to
register for this from userspace, if somebody starts using it now it'll
be effectively broken when that fix comes along, no?

johannes

--=-9QlFVBmnZ7KPeCG6HCzq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLTZ4bAAoJEODzc/N7+Qma0P8P/36XI8x1yIcXYf2IOgTnwprx
OQOum7UObRTiR8g8/qan+FdTDqP85izfQv6ZLauWZTVMDie8+y9h9MaK/Z3xwX6d
FqoSGGxTbEAeBPbE72BgbOL957OehIk/kH7CKCP2DdCGHImfETSD9ucpbQYoKs6r
Vshim/tepH3SRSQTej4snD+gQgcrxI1Q+CzJXbvKN6X7+JHLKP4ogmDKwFwCyk0U
NEK9ZBkcjSmT73JWy6yuqqnx3rkQJRht5udXz60PHwlsp8PkLq7U/iI4ZfkEvlMe
KYhDxbI9/pnbF8UZUCtmM5FPZ+bVa3pSopdqEceM1pDj3qprYWQwwT0KdRpnqbkb
VWKTMk7OdYQRNtBu07UiiKEPGeRibf18FDWWb/oaZE/dgUEmQf6YCv+kJWn73NDl
KctionGGrb+WWEjFpFQs0r/hBckVMpRBCwpHiPZBRwqW6oqRP/q5Rv6X6aUnr8Ci
+B78tVb3c3rLRyO7DEnVXss4vuOdjL1Crw9EpAfqS7tiuraESl6qDWFYOgbJO/Uh
8A+lqcJMsrHdDhDmFix3ObnczkgweBvRKpuu4S7oT3s4duhgfc/qTmUN1NfWgQib
+Rv7KntUgM+E97FFaluJeBToifutGFnL4ai6I6XY8u2OqRiSBoMe2pagqz9mgk9C
Sspc343PDrnnRHR6nOUc
=zZqO
-----END PGP SIGNATURE-----

--=-9QlFVBmnZ7KPeCG6HCzq--

