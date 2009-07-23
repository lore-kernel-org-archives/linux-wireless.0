Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZGWKtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:49:07 -0400
Subject: Re: [PATCH 4/7] mac80211: Replace {sw, hw}_scanning variables with
 a bitfield
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200907231246.56210.helmut.schaa@googlemail.com>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101403.5147.55273.stgit@localhost.localdomain>
	 <1248345497.19121.22.camel@johannes.local>
	 <200907231246.56210.helmut.schaa@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I9Ls3Bfq/Bzl71a2pQLS"
Date: Thu, 23 Jul 2009 12:48:35 +0200
Message-Id: <1248346115.19121.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I9Ls3Bfq/Bzl71a2pQLS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:46 +0200, Helmut Schaa wrote:
> Am Donnerstag, 23. Juli 2009 schrieb Johannes Berg:
> > On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> > > Use a bitfield to store the current scan mode instead of two boolean
> > > variables {sw,hw}_scanning. This patch does not introduce functional
> > > changes but allows us to enhance the scan flags later (for example
> > > for background scanning).
> >=20
> > > +			if (test_bit(SCAN_SW_SCANNING, &local->scanning))
> >=20
> > Do we actually need atomic bitops?
>=20
> No (at least not yet). That's why I used __set_bit. test_bit seems to not
> have a non-atomic equivalent. Or did you mean not to use *_bit functions
> at all?

Sorry, you're right, I got confused.

johannes

--=-I9Ls3Bfq/Bzl71a2pQLS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD//AAoJEODzc/N7+Qma9w8QAKa/N2n30y/FU17j+DOBZ5MW
I+Wp1IY1xUD/Eb1x8JoXmVfg2p3jEbrDZBUdx0bhaAPypZQ3yHoLILM3jEQre1qE
TR1wmQlfo2O45Thno2bSUc2Gcza+aBanG7nb7UvDwm386b+zc/Q4yBYqnnYUHU+E
2sZoR3SgxnlhXDqq7QzHBcw5/asENHI/QUwgKn5LyCfSkO4yND6euLIVc8uRQUGq
5Dedfa91pBAZi77tWZrL/HB1gMXlZQMzrtu20D+jIMhc+XX1btgN0MZm5hpYntg6
f0nChZX72+oGD0bzmU76y2GAncV2Hm4UgqITh7Xvdn+FM6AC3DoD/Ny+SSN5jm/i
0RtrboLgjCtkxJNZIJRskF8jpo7jYqTEitj4qz9/cSKWHz3zux72fCOnKuHGlMzj
L7N1AXKtmfnmmvHGIAvbSoGrCmM5crsXBfnvLSRyzAfCQuzVlakxZiPI1puCOXuB
ZezWVyUIS5Fs7kbDh8tVN4Dyq51JOptYVw8ne91KlFgT8ibZL01rvDry9PPyrLkI
q35sGSoQWg+0neXY7l1LhwqhmHdVFpLPdxrlqS8Up5s/e/A/32yfFtca1Ponj3nL
ygif7ONCS1NOtjp2Pkg4pD4P5mB2D4NYMB2JnvZ3/s2ObfWuZ6l8zxNE4JWto08l
oF1Ph2GM+NGOGwqJRZ6m
=+pT3
-----END PGP SIGNATURE-----

--=-I9Ls3Bfq/Bzl71a2pQLS--

