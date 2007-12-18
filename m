Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbXLRMtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 07:49:21 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217221610.7906f3e2@morte>
References: <20071217012517.882216322@gmx.de>
	 <20071217012550.213561122@gmx.de> <20071217150202.GC3121@tuxdriver.com>
	 <20071217210649.370ba385@morte> <20071217204112.GE3121@tuxdriver.com>
	 <20071217221610.7906f3e2@morte>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p2lNGviIRoejvHAXQvv1"
Date: Tue, 18 Dec 2007 13:49:17 +0100
Message-Id: <1197982157.4885.124.camel@johannes.berg> (sfid-20071218_124923_813390_3A329452)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p2lNGviIRoejvHAXQvv1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I would take this approach: make them selectable (as two modules), and pu=
t
> a huge warning in the help message (something like "you should need to
> select at least one rate control algorithm unless you really don't want
> it").

Please always build one into mac80211 to avoid having the issue again
where people suck and blame us.

johannes

--=-p2lNGviIRoejvHAXQvv1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fBzKVg1VMiehFYAQIA6A/9G7I4P36bjUUo65efUEk0SU6osiIhnQpS
UEMS88nofALA3zN/1SbyRy0c89pHuHYinXphJK/8r1a6V0SwY/n2ofd7vlRAeWTk
vLz530eE4EduIp0eu9svgOo0h/V0BmwU2B4De66+/ANcDlBX/s0HYEXjpou9FqEW
S6cKtDRJ3D0FZ6wOggMutWoT22fiS2pRPVI6hTE6FPNCs50zWhW8PgQGIhfIGLyu
DHhszJRj2zoCZ/HaOs/U+136BtK+/Yu/cBwM6aLEMDdAVg49gNoiNXVO77SCiDzh
G0vhU2xewWh7pMBbBwK3ljUPH6kxWas3dn3EPsWaHRsPrFftZdw6WzWGuy/63bK2
BBWo44rmnEFnBwFqU040NhyN4QnU/goWMoj9aPWWx96fqRsrUQlIciTRHY3AUjue
4D6QfT+GDtG0JT3pAVhsktI+5fdH1RAEhgMc0hXUl/iVRQ6GGwC+KpEuAPe92FZJ
blvZB9lE28p7LFoqJz1GaJCJl63VQiOF3DA+LXgONEU/G/Sc9fJdIBG66zLunoEx
ybkmE1QKcC49uwxshddtQGpVvg2cPhvDjo3I8E/lVM2FrhwenhULBZcDmIpfksxU
bBZPEtCK9vWjznquteLHRtNbVSkNJWceDY9YHELybb0fImjuy3JBD12UIMEpw76O
CjTkBZhfOcQ=
=z8e3
-----END PGP SIGNATURE-----

--=-p2lNGviIRoejvHAXQvv1--

