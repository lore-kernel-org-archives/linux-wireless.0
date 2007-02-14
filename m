Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbXBNT2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 14:28:40 -0500
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Joseph Jezak <josejx@gentoo.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1171481180.6093.11.camel@johannes.berg>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
	 <45CCBB93.2040703@lwfinger.net> <45CCC5DF.8010001@gentoo.org>
	 <200702092017.36950.mb@bu3sch.de>  <45CCD1B1.80709@gentoo.org>
	 <1171457525.11116.19.camel@johannes.berg>  <45D35F65.7060001@lwfinger.net>
	 <1171481180.6093.11.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qwx5SOqUajR2Y6FvD4ry"
Date: Wed, 14 Feb 2007 20:27:55 +0100
Message-Id: <1171481275.6093.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qwx5SOqUajR2Y6FvD4ry
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-14 at 20:26 +0100, Johannes Berg wrote:
> On Wed, 2007-02-14 at 13:13 -0600, Larry Finger wrote:
>=20
> > I've got a pair of BCM4306 rev 2 cards. One of them is certainly availa=
ble. Its LEDS don't work
> > anymore, but the rest is functional.
>=20
> Oh good. Do they actually work right now?

Heh, stupid question if you say they're functional :)

Anyway, I'm not quite sure how we should keep those old code paths in
there. Maybe having a different wireless driver for the older cores
would be good, maybe split bcm43xx into three drivers, one for the
PCI/SSB stuff and then two SSB drivers for old and new cores?

johannes

--=-qwx5SOqUajR2Y6FvD4ry
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF02K7/ETPhpq3jKURAp3pAJ0ZR8s35qPTsdbviiGPHYZbcaIslwCgtqTe
OTlnHHzddI8x5rNMvfbeQlc=
=ZFGW
-----END PGP SIGNATURE-----

--=-qwx5SOqUajR2Y6FvD4ry--

