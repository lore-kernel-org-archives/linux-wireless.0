Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763530AbXIXRUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:20:09 -0400
Subject: Re: zd1211 config operation problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1190654401.18521.272.camel@johannes.berg>
References: <200709231648.17107.mb@bu3sch.de>
	 <200709231348.30055.flamingice@sourmilk.net>
	 <200709241841.50232.mb@bu3sch.de>
	 <1190654401.18521.272.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1pmWivIOL4DzpRt6JgTd"
Date: Mon, 24 Sep 2007 19:21:21 +0200
Message-Id: <1190654481.18521.274.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1pmWivIOL4DzpRt6JgTd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 19:20 +0200, Johannes Berg wrote:
> On Mon, 2007-09-24 at 18:41 +0200, Michael Buesch wrote:
>=20
> > -	if (local->ops->config)
> > +	if (local->open_count)
> >  		ret =3D local->ops->config(local_to_hw(local), &local->hw.conf);
>=20
> Isn't this racy?

Also, shouldn't we then call ->config when the first interface is
brought up or something?

johannes

--=-1pmWivIOL4DzpRt6JgTd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9/IR/ETPhpq3jKURAkGpAJ9g/wpugvwGKctGOQFYWEUYCNWgEACgl8Ds
0ymCeiu19so7r1oEIzfoiFU=
=efD2
-----END PGP SIGNATURE-----

--=-1pmWivIOL4DzpRt6JgTd--

