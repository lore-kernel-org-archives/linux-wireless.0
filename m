Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZG3JzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 05:55:17 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200907301136.40274.helmut.schaa@googlemail.com>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1248903902.8925.1.camel@johannes.local>
	 <200907301136.40274.helmut.schaa@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1JDOxvEvNXjNuT1P6qXN"
Date: Thu, 30 Jul 2009 11:54:34 +0200
Message-Id: <1248947674.8925.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1JDOxvEvNXjNuT1P6qXN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 11:36 +0200, Helmut Schaa wrote:
> Am Mittwoch, 29. Juli 2009 schrieb Johannes Berg:
> > On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
> > > From: Reinette Chatre <reinette.chatre@intel.com>
> > >=20
> > > The connection monitor currently relies on probe requests paired
> > > with probe responses to ensure that a connection is alive. This is
> > > fragile in some environments where probe responses can get lost.
> > > When we receive beacons we can also consider the connection to be
> > > alive, so cancel connection poll instance when we receive a beacon.
> > >=20
> > > The debug message "cancelling probereq poll due to a received beacon"
> > > is removed as part of this change as this case is hit very often afte=
r
> > > the above change and debug log receives significant number of these m=
essages.
> >=20
> > Not doing that was actually intentional -- we want to know whether or
> > not the connection is working both ways, not just whether we can receiv=
e
> > frames. This can certainly be improved, but I'm not sure this is the
> > best approach.
>=20
> Just out of curiosity, do direct probe requests get ACKed?

Yes, they are normal directed management frames.

johannes

--=-1JDOxvEvNXjNuT1P6qXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcW3UAAoJEODzc/N7+QmaFc4P/38n7A2OKL/6nZx9zNwAkxVM
WtITELJn+m2qsKobbOjsQshW13uhlxTZLDKW4YkOnNncvMNvDKO5mTGtQoegZ47Q
7W6/2GlOVU3Kh0C7NxSgPeVMs519wwCnrcc7gZnMjGoNHcPJt5EQfSL38a/I+UA7
z5+wVMTcbqVjWvgbOSjYNTsZPc+swQ+IAzUqzrvBxzGznHDe1VqNYZV5JOQZd0zG
aTZOsCZjgzVG7WShE1Q1HTlIuuALhwrhrYtvn+A1EDKt09xnqYIOumK0ISUV5M/l
7+J7LzGl8q2VlUNySUZ1ZDRSH/D3De1Lo6qS9FtIiLfZIF5viDs+ybK4hVCE9M7g
zia+mphuxoIkmvyXukAW6vXm5Oa9ITjN/85ChaL9v+JA5BATtZTgv5IBi6N14irb
Aq8BRylGP8rpcb/+Eqsbl+Z/OjXKp3o1NNv0Ag2+pefHTfpbrKVecIPt8p+bX6OP
I7tsF5QhlyVpEwHL6mt/kNroITzTFuv7x2iYkuuuasjB0f51AVLEUQIRcLEe52q2
Pb8NPPZ5Vyvr9J22/aFPCTJR43B8CNAbd3R+NDJJfLPTeZ8ro7WKydLVHfVx4tgj
0xC4HcWyrDCN56Gy1wnUks4B3m/wwxaebsbf/qJ26T6z4ybSlfpGZrFpgSj/2Dry
zHPWjPv07PS9x9duk7VG
=sOew
-----END PGP SIGNATURE-----

--=-1JDOxvEvNXjNuT1P6qXN--

