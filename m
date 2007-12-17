Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233AbXLQAyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 19:54:38 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: mattias.nissler@gmx.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217015004.2400ab33@morte>
References: <20071217001956.640555983@gmx.de>
	 <20071217002056.351743954@gmx.de> <1197852547.4885.1.camel@johannes.berg>
	 <20071217015004.2400ab33@morte>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hC4d6vV9wCXxjh5wLEeg"
Date: Mon, 17 Dec 2007 01:54:33 +0100
Message-Id: <1197852873.4885.2.camel@johannes.berg> (sfid-20071217_005454_438239_76F0D477)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hC4d6vV9wCXxjh5wLEeg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > +What:	rc80211-simple rate control algorithm for mac80211
> > > +When:	2.6.26
> > > +Files:	net/mac80211/rc80211-simple.c
> > > +Why:	This algorithm was provided for reference but always exhibited =
bad
> > > +	responsiveness and performance and has some serious flaws. It has b=
een
> > > +	replaced by rc80211-pid.
> > > +Who:	Stefano Brivio <stefano.brivio@polimi.it>
> >=20
> > I don't think we really want to do this. We can't even change the
> > algorithm anyway except by recompiling with a different default.
>=20
> What do you suggest instead?

Just kick it out right away.

johannes

--=-hC4d6vV9wCXxjh5wLEeg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2XIyKVg1VMiehFYAQKQzRAAxYO1AhsA+PoRinUoVnGkZ+/JlUivpwFy
OMXIk18/SOVK1qNs8TdFZpUrphfIbpy3yxaSHouBuBxn4TSw4G1K0oW+ST2sZIFt
Lfw6S+2cxV9s7p0LXozs6HGQx8Boa8IubaiT5GpNuYaO0hkALbprJhQeCHl421qE
+6x2Iye/L9hnVRUqX61dI7melVLuGjDwSVZjC+rY49e6ZaVgY/Ri2qthbvEDFmLb
TNcW3GgG0OvOueBeshkgJRC+m2rVq2+cqqwi5WJ83/ZTzx8dO8PYFt7uD0i5Wlxc
Wqu2o98XTVVcijJ/yZ85E7rGTGSTfeG0KUBy09aqQNUWFdhUnaIQmHF3VtOqsw1c
qvg7cY3wTqdWv/vzHer2wFSO9M8QHkUa204X7QUsjkg3N46qCkZyNbtMvu3C5tpg
I+tCcqtHVlaICDbw7lD5NOksjSmZur9rH1OBMdLlBUFholpQ5tYCYLvHrS8lB9ED
p/iD4jTTYjZ4xBENLAsM0oADF92k5Ar/0pMIQss1BwF3ZykZqSPjOaEefg35Jziy
Qx1WLh3bxf5F6JIYjNyFH3FfKGP4QZJtrurc6l//DBjFVrxznUv19/nZwTPBrIux
61vaK7tcg7ttDi7kBAhZL9nRBjaIL4VRP0C/wQT/1GHwflT/Yi1uXoyDIUDA8LXl
SHEuwufowu0=
=T3DK
-----END PGP SIGNATURE-----

--=-hC4d6vV9wCXxjh5wLEeg--

