Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42600 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbXIXNKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 09:10:44 -0400
Subject: Re: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20070924130715.GA18847@infradead.org>
References: <1190456574.18521.220.camel@johannes.berg>
	 <1190638775.21374.5.camel@dv>  <20070924130715.GA18847@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Sg72jy3GmK9rI/7JkoXh"
Date: Mon, 24 Sep 2007 15:11:58 +0200
Message-Id: <1190639518.18521.269.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sg72jy3GmK9rI/7JkoXh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 14:07 +0100, Christoph Hellwig wrote:
> On Mon, Sep 24, 2007 at 08:59:35AM -0400, Pavel Roskin wrote:
> > On Sat, 2007-09-22 at 12:22 +0200, Johannes Berg wrote:
> >=20
> > > struct ieee80211_channel {
> > > 	/* first part set by driver */
> > > 	u16 freq;		/* in MHz */
> > > 	int hardware_value;	/* arbitrary */
> >=20
> > Please consider using "long" for hardware_value.  Drivers should be abl=
e
> > to use this value as a pointer to some driver-specific structure.
>=20
> If you want to use it as pointer better make it a pointer..

Then we'd have to have two values. I don't see a need for having a
pointer at all though. Pavel, can you show a driver that really benefits
from that? And explain why it can't use an array index here?

johannes

--=-Sg72jy3GmK9rI/7JkoXh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG97ee/ETPhpq3jKURApWDAJwNsJDtAy3vuub3v9cKydI4sbaKdQCgpDl3
qKL8HnWZJoLuj1C+nBUgamM=
=yprY
-----END PGP SIGNATURE-----

--=-Sg72jy3GmK9rI/7JkoXh--

