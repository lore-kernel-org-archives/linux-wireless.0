Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXIYVnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 17:43:00 -0400
Subject: Re: [PATCH] mac80211: fix interface initialisation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200709252332.37064.mb@bu3sch.de>
References: <200709252206.57855.mb@bu3sch.de>
	 <1190755892.18521.330.camel@johannes.berg>
	 <200709252332.37064.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mCDFZtkx4S8VypLEIHYh"
Date: Tue, 25 Sep 2007 23:44:13 +0200
Message-Id: <1190756653.18521.332.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mCDFZtkx4S8VypLEIHYh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-25 at 23:32 +0200, Michael Buesch wrote:
> On Tuesday 25 September 2007 23:31:32 Johannes Berg wrote:
> > When an interface is registered it is still uninitialised so
> > ieee80211_if_reinit() can't be called on it (it will oops.)
> > Hence, we need to move the uninit method assignment. Also,
> > this patch fixes the bug that the master device is never
> > initialised at all.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> I guess you should send this
> To: John Linville
> instead :)

yeah, I did reply-to-all and sent before I changed it. John, please pick
up.

johannes

--=-mCDFZtkx4S8VypLEIHYh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+YEt/ETPhpq3jKURAptAAJ0TcMHi5SacIsGRopvYRLJWICcLMgCeJDsS
hqPFX+1VsqyckJpwHJ4MRJs=
=v7oR
-----END PGP SIGNATURE-----

--=-mCDFZtkx4S8VypLEIHYh--

