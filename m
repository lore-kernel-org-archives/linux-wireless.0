Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZGWLAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 07:00:00 -0400
Subject: Re: [PATCH 5/7] mac80211: implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200907231248.36825.helmut.schaa@googlemail.com>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101411.5147.78380.stgit@localhost.localdomain>
	 <1248345547.19121.23.camel@johannes.local>
	 <200907231248.36825.helmut.schaa@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-u65D8IdjkT7umggO3xZR"
Date: Thu, 23 Jul 2009 12:59:25 +0200
Message-Id: <1248346765.11510.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u65D8IdjkT7umggO3xZR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:48 +0200, Helmut Schaa wrote:
> Am Donnerstag, 23. Juli 2009 schrieb Johannes Berg:
> > On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> > > Introduce a new scan flag "SCAN_BG_SCANNING" which basically tells us
> > > that we are currently scanning but may as well be on the operating ch=
annel
> > > to RX/TX data whereas "SCAN_SW_SCANNING" tells us that we are current=
ly
> > > on a different channel for scanning. While "SCAN_BG_SCANNING" is set
> > > during the whole scan "SCAN_SW_SCANNING" is set when leaving the oper=
ating
> > > channel and unset when coming back.
> >=20
> > I think you got that description wrong :)
>=20
> Argh, yes. Should I respin the whole series?

Not for all I care, just resend this one as a reply to it?

johannes

--=-u65D8IdjkT7umggO3xZR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaEKKAAoJEODzc/N7+Qma+BkP/3ZjoTBHUEfKS6BbTjYt4Qnm
DNVOCG5rBWYUGFevAqkNbWoDkYuFoZT2JYkHYMjmesvwqaNGL30UMx7DJS5g5h5M
rszJHlYBMMVVaXvCUOrc+aCguf535cavklCFfbd18PLT//wIK1MOZTrMOmC0Z/kh
T6W6tAGPmwI4R4Lekuo/BY6wnbTx1Yf7teQTzFAsbiPO5O9bkKOZ0xDuNnb9MaJv
4C2lwONauwS9bfi8ww+vmnMx7zcwnVUqjK8RWdlEFGbvuEEOzDG7IO8+Povaxk2+
tRaH2jgLE43fooeysQpgKDfx8Hw/onoiWpHDwmO2+qQl2Lze23hVObPLMz7nX2+7
JgWeDDpDH1vFUkCvfy2whwmSb3L/IAOJtN81SPtiZij3E57ZAzdwC1khlnlDBDmc
nFijZoKvHmqIb/oEhoURQm1imaez0mUCjjquOPWi0EMDeXbheFBGs5BOl+0TYPz/
xMbGz6YICHkVqbU1o5+snr46Ofg8kYdajpe1+Bzt0LOUvECLO+xxu2AdFNjHesy+
YsIBBZ+l+Dz3Fhn6XCA92+rIFYNmwo9bCCQz/kEOWvYnfX/8RziTDgx5JcsyPb3m
uAUt39bVUlpckklg0BFCaqLJSWikDzEGwZ0QyGDhxaa8ya7EfbiMx/LX797ncnSS
rzTLVVXpnKwMtJtAyq9y
=e3Ae
-----END PGP SIGNATURE-----

--=-u65D8IdjkT7umggO3xZR--

