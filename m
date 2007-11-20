Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXKTNt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 08:49:26 -0500
Subject: Re: [PATCH v3] remove bcm43xx
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@suse.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	mb@bu3sch.de
In-Reply-To: <jehcjheubn.fsf@sykes.suse.de> (sfid-20071119_223649_028329_2561B167)
References: <20071119202121.6ad3fa70@morte> <200711192300.12183.rjw@sisk.pl>
	 <20071119231935.535674ba@morte>  <jehcjheubn.fsf@sykes.suse.de>
	 (sfid-20071119_223649_028329_2561B167)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S1nAUWVj5res2NhmztUY"
Date: Tue, 20 Nov 2007 14:17:18 +0100
Message-Id: <1195564638.10920.15.camel@johannes.berg> (sfid-20071120_134928_897345_9E3A48D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S1nAUWVj5res2NhmztUY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > The maintainers know. Having both drivers in 2.6.24 should help find ou=
t if
> > there's anything which should be ironed out with b43/b43legacy, but rig=
ht
> > now they are already working a lot better than bcm43xx, and they are mo=
re
> > stable. So I couldn't find a reason why we shouldn't remove bcm43xx in
> > 2.6.25.
>=20
> b43 still does not work at all on ppc.

That's completely false.

johannes

--=-S1nAUWVj5res2NhmztUY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0LeXKVg1VMiehFYAQLVeg//SmQWwoAPkvUHvk0KGADOwA8CkRc6fy4H
31HUwMhsRi3Q4kywjOsTDUhx3yE3soJWohxyP4UNadoMT67ZisSH54jiXm0+EJtd
M307D1jhapfgC4FWouPQXwc5ciHomtF9Nt7xcEIeJzVu/949cZZVN6RVl+1FihdX
VlCiOkaoRIbGuhZ8T0Gnq+TPcn/9UnIQTbjTQQNZrh7ONutyhgvF2ZJ5VHV6HuVm
s3/Um/GOZR/Sn0IXB+o2Ow7sY7vxQO+NbwHZCGIo0t2S7VELO0KLngJfuuZopxkx
oWVoJiSo9QzjCpJ3zGFbbtOZZBc6pTGzjHJ9IKf4S8deuydHPxcff9FvqjDn7ZYG
t0Gl2hgFSUitAJnA9jPA7H1SG8UczafYMkRSWSRL+UdabiiIQIaZaNj6iktYT+RR
y50RWaKY6rOk0VXl2w6i4JhDEEX5Z8iedOqNezai4ZdW+m7J7pzvySUXMf3oHLC4
UeJh6FEEkcYL3udH5ygQn5/mB2m0HitN2C1cWFza19kN/ZnFpoxqzk5Jyv7D0/Uo
tjm/vIuqnQF42iPUm1Ggn0TnOcss2MWHXtxLTzzF6GSDWMb74k0iIF4TTQh5zAgJ
b5ZaxE1gCqQKrCnK++P+OyNzBrueiD4lxOrmEFACTIOzgGpTWobs1lxaW20ztWCu
McHqDvsv8Xg=
=EFvE
-----END PGP SIGNATURE-----

--=-S1nAUWVj5res2NhmztUY--

