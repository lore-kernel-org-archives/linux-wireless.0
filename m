Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXB1P0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:26:07 -0500
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281612.51383.IvDoorn@gmail.com>
References: <200702281507.13004.IvDoorn@gmail.com>
	 <1172674256.5015.15.camel@johannes.berg>
	 <200702281612.51383.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lWykVD3RXkqFHpPkgC4C"
Date: Wed, 28 Feb 2007 16:25:38 +0100
Message-Id: <1172676338.5015.20.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lWykVD3RXkqFHpPkgC4C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 16:12 +0100, Ivo van Doorn wrote:

> Is there any particular reason for RT2X00 to be a config only option?

Not sure, maybe just preference. To me, when going through and not
reading all the config entries, it appears as though rt2x00 is just a
menu but selecting it still means code is built. Maybe there's the
solution too, provide a new menu for all these options, rename RT2X00 to
RT2X00_LIB and hide it by not providing a help text.

> When RT2X00 is a config only option, it would still require RT2X00 to be =
a
> tristate option.

Good point.

> It would also mean that both RT2X00 and RT2X00_LIB are options the user
> can select (RT2X00_LIB  depending on Rt2X00 off course), I can't really s=
ee
> the point in that.

No, that's not true, if RT2X00_LIB has no help text it would never show
up to the user.

johannes

--=-lWykVD3RXkqFHpPkgC4C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5Z7x/ETPhpq3jKURAtANAJ4kPjinLTvukshqw50LKzUvSXforQCfV3VC
JDKKx9ccakCcSNJXa6S529w=
=hNid
-----END PGP SIGNATURE-----

--=-lWykVD3RXkqFHpPkgC4C--

