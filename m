Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZDTPlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 11:41:52 -0400
Subject: Re: [PATCH] ar9170: rework rxstream code
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200904190128.13206.chunkeey@web.de> (sfid-20090419_012821_861639_E6D0EBF4)
References: <200904190128.13206.chunkeey@web.de>
	 (sfid-20090419_012821_861639_E6D0EBF4)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gi16JWY9xwvCvBFrccCV"
Date: Mon, 20 Apr 2009 17:41:19 +0200
Message-Id: <1240242079.4632.0.camel@johannes.local> (sfid-20090420_174155_839361_899D7C4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gi16JWY9xwvCvBFrccCV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 01:28 +0200, Christian Lamparter wrote:

> +static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
> +{
> +	struct ar9170_rx_head *head;
> +	struct ar9170_rx_macstatus *mac;
> +	struct ar9170_rx_phystatus *phy;

Missing =3D NULL here for phy.

johannes

--=-gi16JWY9xwvCvBFrccCV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7JecAAoJEKVg1VMiehFYS+wP/jejnDJMHLlc8ozvShinp4ac
pS2/h2rKEu4OnjDZZr+luXUD3aghVs4rCPrE7r0VRwuQSVk7sUE4b3oZd8BKs4qr
VclO/LuauH2tGD11Xt1vWLRLva0bXG7Furz1XKRDx+tfYXRDLWOTjUGHMP2jJ9px
9yykyNNIF1vIWJfe/yRafljSyNZ2i5fN5exuRnuymJCnQFmUKRtcDMoOefsUFbFm
Ab4rnRI6YDYmciiCCHjON3LdgwmjN9n+UTOx6UtXqp9Turc9LQAMYgtkN9fbO8+z
bMjxMZpXxvlcjG7WYol4o1H7O+XcgSy+mFfbCL+llLpaLI4+9fwMXIJU81qh/SB6
QjoOeNwxY/VfZl6IcIbLRBv4TwEKEcTzPvI/mc3a9cxM3KE2rY3unSag8VtoEK6I
WTADkHIx041CcuII57rHyJFaMONSgLhZesvED+0ayAJIykek5H62nU4OAQ9C4VAU
c9gbbYmlh+hS/ccj2fxNLI4Gvw9TX1eDgIqP8YJUNGqFVUFG0gmhVJSdjOngC8cO
MMDWZMHNkz+chU5ECfnxrrkAPpdpg3WC8M90zcqKI/vRxs5Y9yxTdHW4PAbhfwKj
tWtARFhVmKOa1+3joqUElF4R/s1IBjGnrobcgia92RqVNn1xLDR52NeZLG0CuBox
AJlZtxU3o/RmQSNfOaFa
=GJCq
-----END PGP SIGNATURE-----

--=-gi16JWY9xwvCvBFrccCV--

