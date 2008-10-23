Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYJWGY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:24:26 -0400
Subject: Re: [PATCH] wireless: update regulatory sample code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081022144056.GM6190@tesla>
References: <1224701752.30459.53.camel@johannes.berg>
	 <20081022123505.GI6190@tesla> <1224704488.30459.69.camel@johannes.berg>
	 <20081022144056.GM6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tzXK9Rvozt7/egFy7JXQ"
Date: Thu, 23 Oct 2008 08:24:19 +0200
Message-Id: <1224743059.5865.8.camel@johannes.berg> (sfid-20081023_082429_156500_7CF4967C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tzXK9Rvozt7/egFy7JXQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 07:40 -0700, Luis R. Rodriguez wrote:

> > > Should we mention how currently this should be avoided unless
> > > your regulatory definition is also intersected with hw capabilities
> > > and that the same channels are the ones that are registered to cfg802=
11?
>=20
> Well rd hint for when we provide a structure, that code right now
> disregards when initiator =3D=3D USER, and this works well only for
> when the driver sending the rd struct hint also only registered
> to cfg80211 the channels its legally capable of. If a driver
> which does not use reg_notifier() and registers *all* of its channels
> uses this then the USER set regdom will be used and *all* channels
> will be left intact.

No, only those that are available from CRDA will be used. And this is
totally irrelevant in the case where this applies anyway because the
Intel drivers register only the channels from their eeprom, the same set
they hint at. Yet it's still unrelated.

johannes

--=-tzXK9Rvozt7/egFy7JXQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJABiPAAoJEKVg1VMiehFYLIMP/jw7JLbY2/dJtED7ns7s33V4
7Hsa3DNlA8KgUmk7oCxBFZhsNLN+cxsVXEkYc4cOL5I4smWIwYRHkJBzmkz0EX6c
ka9WAktnKV56RCvML6RizBi/RcX6RcbUK9P0RdwU1g5XGNsRM5HbdSqWw5aiE9i0
NbAJ65iGmA4njvWorRFQvDlxdMi0vaABk+xVAh1a6TWaTq9bWG+Dd+RmJ3GFiFhJ
bW+PwuZYVyS6EMERaBxNVbjQEMMt/tkQb9S3ataG4RDOHD6Hhi81NhjPYcEYTUV3
q0DyIOxfT04s8VkJ/z3cWtkQPFRnsHnUFZnoB47qgsWhH7R6eEBg53y6kvKdmnlf
ZbuYc8UWz5iPIj1pgrHJJ0oeElmsowzn8iVaYZHVawY+WhKhJTOO978S7na1X3o6
ApxK/61Lm0riKkV1xvs7yZOjp4+e583tECH3t8wvitmq2zHJ0F2+wg3Vc/yrhKkq
gSWlZ0bMOa32HQviBgmy+Dv7ya//901gnLnmsvLe8zYiDIkDzoUBYO0tiCLBTCuc
idwXMTHHglZmta0EvzBpVSognPREVpF7BdwpMjezQen8x+MililBuWv7sdH7AAz7
QOFgY/R9PEOdP+z/d0PiXB9dmFU4HYdmAbVRn+pSL8vG1eobbbRALKkcV0bLdOlr
75r/ULEJx34JYQZHmT+j
=91uT
-----END PGP SIGNATURE-----

--=-tzXK9Rvozt7/egFy7JXQ--

