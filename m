Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYGALHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:07:37 -0400
Subject: Re: rt61 and TSF reporting?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200807011305.18802.IvDoorn@gmail.com> (sfid-20080701_130101_443742_9C502412)
References: <1214907990.7763.40.camel@johannes.berg>
	 <200807011247.57739.IvDoorn@gmail.com>
	 <1214909314.7763.43.camel@johannes.berg>
	 <200807011305.18802.IvDoorn@gmail.com>
	 (sfid-20080701_130101_443742_9C502412)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PfDVWoqGAxvZnaBEIKLH"
Date: Tue, 01 Jul 2008 13:06:45 +0200
Message-Id: <1214910405.29181.0.camel@johannes.berg> (sfid-20080701_130740_297045_A24D4504)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PfDVWoqGAxvZnaBEIKLH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > Note that these undocumented fields only are present in rt2500pci and=
 rt61pci.
> >=20
> > Ok cool, I'll play with that, I should be able to make a patch myself,
> > thanks.
>=20
> Oh wait, just found a reference about those RXD words:
>=20
>  * The following fields are for DMA block and HOST usage only.
>  * Can't be touched by ASIC MAC block.
>=20
> In other words, they are for driver usage only. :S

The only ones that are ever non-zero are 0, 1, 4 and 5. Guess not then.

johannes

--=-PfDVWoqGAxvZnaBEIKLH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIag/CAAoJEKVg1VMiehFYjZ8P/RqRFXtbS7sb+lUnV1Hg2YJg
V/nbDiHSRchIFKGsJ2hz/VD2fDrF1yiTWKHjTiRK26Jgh+PCuD/Rk0nOhTZIi8KJ
OI0/YXysRZUSPnYfJM0SkiBezebXYOfVegbx5hkSYh06R6rcQaN4fG2R+PL+Y0I4
lG2aQDc89dt3e/KZUD7nIS3FpeTumwHctXcTLzbA8BaATqYkMf/VJo3uz2LWbQgI
i8u6oQ6J/BsmxPYLYgnWdbdMULZ2IRdZr3FtwTX4zwi5bSIyaX02/yqST4ubtp5y
eFoSSwlKC3KK1BxwDSWNA+CVBE5I+0XQJlAnznsuBUoCKE+g2WnRt5FzzYSsI3rh
mXKkxMdenvGifXvRMcV6sck2AQhoLRT4YQhTDUIOyo1QjNPNaCytwuCncPpW9Z5s
25K/y+FV2FC9b68BYWpsYyIMlPKDRM1MG6Me1oyJ8wimyZxRguoZ5rk9oN1S+6/x
0VFQxnec8XmmtA2+DVaPVZiLH0QtiWvgHd3kuqCB2XG+L9+fYtMX4Nn2y981TMjT
mbuoy4W9m91zO0PxBQ2AgMsZ2XT18N3JzULjuOmyiJIx4UKdEQPQpWLunXgU8WmJ
/UXuKzm7lyiUJiZEqmcjKR+EF3Oq4kGi+bPXBgEd8V8wESadByuvjnmGOUMAbIeg
hc431rTAp15EaqSMVuem
=igcU
-----END PGP SIGNATURE-----

--=-PfDVWoqGAxvZnaBEIKLH--

