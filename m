Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbYG1PHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 11:07:22 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217257174.28198.27.camel@localhost.localdomain>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
	 <200807281600.39103.mb@bu3sch.de>
	 <1217257174.28198.27.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GdmhWOLE7dlP6iPW9++A"
Date: Mon, 28 Jul 2008 17:07:08 +0200
Message-Id: <1217257628.15381.2.camel@johannes.berg> (sfid-20080728_170752_212468_041C3DAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GdmhWOLE7dlP6iPW9++A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-28 at 10:59 -0400, Dan Williams wrote:

> > If that's really a problem, yes. 01:00:00:00:00:00 is still better
> > than a pseudo random MAC, IMO. It's immediately obvious to the user
> > that the MAC currently is not set.
>=20
> How about 44:44:44:44:44:44 like orinoco uses for bogus BSSID?  If we
> can, let's not keep creating yet more bogus MAC addresses.

Either way, the problem is that these will confuse udev if you have two
at the same time, no?

johannes

--=-GdmhWOLE7dlP6iPW9++A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjeCYAAoJEKVg1VMiehFYJ4QP/3fCdcES51uNpf4ZM4i9Aofn
Rni95jrFumZ732Oyc1xTh657/LhGhnj5Yogaxv+rI7UoaiotriwALzHQ543bHN3z
bdSg7wv7VcCyRwsrwvhv9UwFbqloW0fza1uj7/XxREIN+CvwdQPtEDTkGV1mBCak
XCKqRxYioOzXqCS8eKJTjveAN2WU+NLiYUU1Z4uU4dX8aMpYa5/tFaNrD776yb4D
rIh5WyDfY7I2BivFimf0nvvVuaqpBjoCDB6S6k1kyvpBS+8BqEF4TBwUYDnTcmTr
O1+/7a1cVI8f3iMwhpZqr4XzmFpW3ZURurpYQTiphFOHEVxZgPxgUgAmSRHbgd+B
GEVMju9eAiC4hNKJBDVGi8y9d44vBSPNszgcC/rIBVVqA8brmyruWwBwJNFge4VC
4f+Zx15Z0XgFau4P9fHURIHXUPZPDpGAFp4lQezbo7DB6TpUU2NVgx+MVWTkWXlX
3JGb8YKiPzlMRMmq/Xz+K1ponbifVi7xSxT9mF623Im+sJwVZZIR2xT7sZ87iU/G
UJrR7SwxesrIz1SJ6oCpNmSkhZ5ZeZJoEWJL7D7zv1vqIusw8cGg+GO9IgNohnJS
Rbfj+anStzHwLbexABMs2rPEjycExK4uxCqGoXjwDfl6CC/CpQ8qHp9Bjy5nrMxd
ajArlQwusdyvPDDCgdsO
=6fVx
-----END PGP SIGNATURE-----

--=-GdmhWOLE7dlP6iPW9++A--

