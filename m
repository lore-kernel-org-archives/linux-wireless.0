Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbYBYTu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:50:57 -0500
Subject: Re: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1203968745.6929.30.camel@localhost> (sfid-20080225_194425_609760_1B1ADCFD)
References: <47be76f9.03b48c0a.025f.54f4@mx.google.com>
	 (sfid-20080222_071727_691746_9DC8AC76)  <1203693709.7082.35.camel@johannes.berg>
	 <1203968745.6929.30.camel@localhost> (sfid-20080225_194425_609760_1B1ADCFD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jlNyQ97Lxg6YbwwR4reG"
Date: Mon, 25 Feb 2008 20:50:40 +0100
Message-Id: <1203969040.13162.145.camel@johannes.berg> (sfid-20080225_195103_397054_F3D39512)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jlNyQ97Lxg6YbwwR4reG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > >  - We no longer use directly rtnetlink for mesh peer link and mesh pa=
ths
> > >    operation, and use nl80211 instead.
> >=20
> > Nice too. What does libertas currently do btw?
> >=20
>=20
> iwpriv...

eww, ok. Guess we can convert that, CC Dan & David.

> > > I would like to point out that it looks like we can get duplicate sta=
_entries,
> > > or more entries than the maximum allowed, if stas are added at the sa=
me time
> > > through normal network behavior and manual operation through nl80211.=
 Please
> > > correct me if I am wrong or if it is just that no interface type is s=
upposed to
> > > allow both kinds of additions.
> >=20
> > I think I CC'ed you on the patch fixing that, no?
>=20
> Not sure which patch are you talking about, anyway I will check that
> along with the mesh + sta_info changes testing.

Subject was "mac80211: atomically check whether STA exists already"

It didn't check the number of STAs since I thought adding one per CPU
more wouldn't hurt too much ;)

johannes

--=-jlNyQ97Lxg6YbwwR4reG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8McD6Vg1VMiehFYAQKYaA//deDLhh/xLftpZ8JQACkkzRt0+oMp/yuW
bIgjnck6zV2NKmQDENSSN5qSoANyd0pwgKHUFnW7EO0reRas8ucpN0YNYFIZZPLS
Ejop4kWLXMA27ZCuppiGxiHXPV/SOU6AeZFAdHqftvVd4ixqcWKhIN0Ou4DMybov
jfOxw4Zvh4rT10clq7mzsOXAL8+fZwnC+C+gNt0osfxpt+QFwEQ5+ut9gvEbit87
hRbDBevho0Y9SD6DhYk64L6AZw1jm+mj5Qhrd9hRgGL4Qx/lHHxoHShAG+cPbfYZ
49MGJpNnz/R/guo8d4k6JFlU18MzaKbkVTlJywhhtfkTyofY2N6jdVOOEBaLFFYM
CHWFlHX0k9NoCfC0DwiX7zyBwPAFcF4/ZCeDY9xDbHyP0cXqtwXkt27vahga8+r4
vc3Luxkmxq2xiqqShLYL+vkXo/Jh9KRIG2NeFZ4i+b8M//WkMRXRZHXiT/O35p6Y
Sm4sPVVUYMEeTGgitS5ippbPl2vEanMHk5n5Xi1UdNrEnaHgWXQ1LRFQz/j/IxFU
puNMIGFjKqBvalDQNlBCppR2ZarxtHJCzyiWIgCis7gZBdUz1FsW/xcW2mcGz05O
bLYElhFLyIJANGhQuAy3dL+NMlGZtRfqrtphz//uNqdtQr3vD4dmQjkQyfo0SVS9
PqqDQg0Oj8s=
=ALa3
-----END PGP SIGNATURE-----

--=-jlNyQ97Lxg6YbwwR4reG--

