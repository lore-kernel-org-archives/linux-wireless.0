Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbXB1UJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 15:09:42 -0500
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Cornelius <robin.cornelius@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <1172692940.5015.85.camel@johannes.berg>
References: <200702281507.13953.IvDoorn@gmail.com>
	 <200702281752.36875.IvDoorn@gmail.com>
	 <1172681674.5015.43.camel@johannes.berg>
	 <200702281809.15486.IvDoorn@gmail.com>
	 <c4db5c50702280921i6f0689adm197b5fcb19f1852f@mail.gmail.com>
	 <1172692940.5015.85.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uwhWoUt6e9fOZuiukHSb"
Date: Wed, 28 Feb 2007 21:09:16 +0100
Message-Id: <1172693356.5015.91.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uwhWoUt6e9fOZuiukHSb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 21:02 +0100, Johannes Berg wrote:
>=20
> CFLAGS+=3D-I $(PWD) '-Dieee80211_ptr=3Dax25_ptr'=20

The -D... part is of course bogus since I did the sed script. Tried this
way first but that doesn't work since ieee80211_ptr isn't void* any more
and we actually do -> on it.

johannes

--=-uwhWoUt6e9fOZuiukHSb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5eFr/ETPhpq3jKURAkfaAKC63QYrHBjyoFCc9JJESa5rq+hXiQCeLJUP
2me9qP8G2zqssh/KMzvadFA=
=YbMk
-----END PGP SIGNATURE-----

--=-uwhWoUt6e9fOZuiukHSb--

