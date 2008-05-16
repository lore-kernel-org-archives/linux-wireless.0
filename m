Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYEPXHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 19:07:49 -0400
Subject: Re: [PATCH 0/2] mac80211: use multiqueue netdev
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
	Ron Rindjunksy <ron.rindjunsky@intel.com>
In-Reply-To: <20080516225712.794319000@sipsolutions.net> (sfid-20080517_010406_688360_A94C84DB)
References: <20080516225712.794319000@sipsolutions.net>
	 (sfid-20080517_010406_688360_A94C84DB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ktmcCEvPRIKx9lmKF0JW"
Date: Sat, 17 May 2008 01:07:36 +0200
Message-Id: <1210979256.3827.1.camel@johannes.berg> (sfid-20080517_010751_701651_98C8054D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ktmcCEvPRIKx9lmKF0JW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-17 at 00:57 +0200, Johannes Berg wrote:
> This patch (well, there are two, but the first one is just some
> sanity checking) converts mac80211 to use a multiqueue netdev.
>=20
> The next step will be to re-do fragmentation taking into account
> proper A-MPDU handling etc. but I would love to have Ron look over
> that too since he's much more familiar with the A-MPDU stuff.

Ouch, sorry about messing up your name in the CC list, Ron. (and if
anyone else wants to reply substitute the i by a y like I have done now)

johannes

--=-ktmcCEvPRIKx9lmKF0JW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC4TtqVg1VMiehFYAQIjTw//exH5Vsnk1vHxxNgQl/sp3JBRO0U52Kf2
OZFBnlUptBagC5vdsewJQuF2c7effs8UccoHwMwxiyQsDXtgXohQnzvf7vMtHM3n
7Czy5XdS245JAt7DccbjuEdiUpULEPwMOx484yzt4DlL4MvgaP6dFkg5ID3sX8HI
QS8+DxPomAHNiWm07vrn+mVl4zs841po0fLHcAbPR3LYEjWqB7d9gc1AfjUEw8im
RwxO4a3F+9I21aOO237C4Pp8NOarq7z2dj/kSCEgM4OUbC9OHONQaHa6VJD8Up2z
vBhU1uXQctKKUESc8bqBrkh3IE6ExVSIsRwY/OhcuPXFqe4zHXt2vMoAKYchz8jf
SOm+gYv5z2Ze7/QaJhC4YEQBFD2uXV7U4m4+qa99y1nDvLKufs4xZdk3gNQFsaU9
B8B970U//vkcNmDAYdQxzqmxOF017FsT8ZyLG6M+mo2gwTBnxjQdF31EgXPUyJIM
HNNEei7j51oimfhRsHYrzwPID2DQLwK3pbDv3Z5n7T11W804IyIf8meEuBagw0FN
3wRDvhXbTHWJerjzT3GFjQWoEwpiFjSUsEvbIzfeZPmZYMoBlEKeiGWo4MRDN7hD
e0RNUD4e4l7xJgFPsYxd5UB3/ayfbhod6EjaMaWbKZ47tWa6kQLWBxQyA1v+X6Ak
jwowKN7LA5I=
=jcZO
-----END PGP SIGNATURE-----

--=-ktmcCEvPRIKx9lmKF0JW--

