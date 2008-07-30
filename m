Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYG3Gqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 02:46:31 -0400
Subject: Re: [PATCH] mac80211: fix more kernel-doc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20080729205916.c4c6c363.randy.dunlap@oracle.com>
References: <20080729205916.c4c6c363.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f0w6IBGuIB3mJfHmTNHK"
Date: Wed, 30 Jul 2008 08:46:17 +0200
Message-Id: <1217400377.10489.79.camel@johannes.berg> (sfid-20080730_084636_108500_B74FC83D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f0w6IBGuIB3mJfHmTNHK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 20:59 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix several kernel-doc warnings in mac80211 header files:
>=20
> Warning(linux-2.6.27-rc1//include/net/mac80211.h:759): Enum value
> 'IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE' not described in enum
> 'ieee80211_hw_flags'

Thanks. That one, however, is already gone now, I had merely forgotten
to remove the flag completely.

johannes

--=-f0w6IBGuIB3mJfHmTNHK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkA41AAoJEKVg1VMiehFYQCIQAJZJkERfbOaTo3/5Of9aZtiL
SPQwRn1LRBk5KQ55qIcy8Y8L0FfoshqBoZJiY1kmEJOVsLRZ9ANCSOGxJN0mKQaj
cTtbgVRGD269DpAt7LI24RV9rC7xp1BF3LbsJeyEKJl6IQHfdpck9QZyOtvvsIwW
qR77GlXHVfeaPsKM6VzvybpyULMHvU3Y14V0FVJaUYFWBz8YzCw/ivGpPjmWAwfC
Qu+kCpwpiv/4tI47wjrTiykJY5QFtGV7+3MHAWEDGlQtnR7oWeEqLPkWqorOQ9HA
DJiXIePsBCS/hPw+LaZ3N17T+CfVlglTvmcqVT0LBGX5p+cQ/ZlOXENyCP5N0UpM
OhnlWQKvXLpD3+ypJZ5qFdXd2IX5guinnCypocq2/2jQtAviJ8jNP8A9yTWt8w4F
atDg74RoavYs38eyQFCeY5CtIx9cBo3WKmUhTLKaw0y36livNMMtaqEbkzpi629z
c3v2MaYY6hATDICJaJzwo8XWH4TWdVidLALquLFAaiPRKZuxW271JADBYdN/Cggl
/DOGGYJhr5n2ZqbNeqiFwaetzT+GH4JzgapmtnV+pewnZLNDS5JvaTWtdOE74BCU
vATyzK3NhWLQOB4ebq31GXGrvEo1fAt2UOWoPQ2pXQufa4SS98XUGcnMsM0g3/Rw
X3lJb6vQ6QgntUUabKt+
=NbeQ
-----END PGP SIGNATURE-----

--=-f0w6IBGuIB3mJfHmTNHK--

