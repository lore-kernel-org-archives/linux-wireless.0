Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbYIRR6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:58:05 -0400
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200809181952.15770.IvDoorn@gmail.com> (sfid-20080918_195224_932237_E9E182C0)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net>
	 <200809181624.53050.IvDoorn@gmail.com> <200809181944.10018.mb@bu3sch.de>
	 <200809181952.15770.IvDoorn@gmail.com>
	 (sfid-20080918_195224_932237_E9E182C0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nQ9xGt5hIsp8/apOv+OE"
Date: Thu, 18 Sep 2008 19:54:09 +0200
Message-Id: <1221760449.9262.96.camel@johannes.berg> (sfid-20080918_195809_195505_EC84DF43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nQ9xGt5hIsp8/apOv+OE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 19:52 +0200, Ivo van Doorn wrote:

> From rfkill.h:
> 	RFKILL_STATE_SOFT_BLOCKED =3D 0,	/* Radio output blocked */
> 	RFKILL_STATE_UNBLOCKED    =3D 1,	/* Radio output allowed */
> 	RFKILL_STATE_HARD_BLOCKED =3D 2,	/* Output blocked, non-overrideable */
>=20
> Since b43 has a rfkill mechanism that does switch of the radio when RFKIL=
L is set to BLOCK
> after a key press, it should send RFKILL_STATE_HARD_BLOCKED because rfkil=
l cannot override
> it.
>=20
> rt2x00 hardware does not change the radio state when RFKILL is set to BLO=
CK after a key press,
> the state is therefor overridable and it can send RFKILL_STATE_SOFT_BLOCK=
ED to rfkill.

If rt2x00 has no meaning of "hardware blocked", why is the button not a
simple input device?

johannes

--=-nQ9xGt5hIsp8/apOv+OE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0pW+AAoJEKVg1VMiehFYmv4P/jNkFvmUDi6P+ziftjQcND8N
Cm9NS3S5UGa3lriZCY+HevrPKzAxPDZ8NRioH20o6xKdOxsYvkQLSNBoRyMmjAHA
8n40Zc8LWwQLh+fFHCtbEQ4fC4R2fjwxSBbeDtg9GwaZZGwObCGnP3XRMHOkE7mW
q4gTJtCObnggqm7+ekiCkgcXkCchO4wuuY2O96zAcSaE7SS0hubDwjLE2K4cB1g6
uGtEoU3t+BufKoEHpXitBco0kOhIMDnLjfwj6ovO66vICGRmw3kwkHHJWRqoWG8Z
0IFQDnMGTdfI2mFWpaFTaCQuRRQzJG30+nRLVGMJRYyDfBH3CEkl6NTi9yQv2Oz+
OFqft+7MXqEAnzXdiV4lkrDP9csyro6W/bi2c1X+UVs1I8+vN/E3C99F0cZ6Jts8
R2280s3fvpXo0la0qQ36vQe+2YFIhO7WIjKm9kxCmNie88PjzcRQbwSjmOALNqxj
ajQYxuEGX6IbDuIUIVb0t/K+ww2NT3ans6ELNuzMqACjXLLkpoCb8xlozhlA1j72
NoUdU8pZsNokdqwtJNfGqgjg+fzYngCIyi7QplvQUBJ5+gdkIvLzkaESeQCt678d
m+8RvlUZoK5gXEShLeXb3Fh+iMOcLk1FP5jMMbrj24JULRXBAyx1k3U6sCoiZrdW
/Wfl9lP4BfpwonZXLBpx
=wLdr
-----END PGP SIGNATURE-----

--=-nQ9xGt5hIsp8/apOv+OE--

