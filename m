Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYBLLZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 06:25:21 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <200802121225.02045.bruno@thinktube.com>
References: <1202209693.4395.29.camel@johannes.berg>
	 <20080206024957.22838.82194.stgit@one>
	 <1202341955.9965.26.camel@johannes.berg>
	 <200802121225.02045.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xfL7AKRyrqLXqQ0cQCK7"
Date: Tue, 12 Feb 2008 10:52:03 +0100
Message-Id: <1202809923.11481.89.camel@johannes.berg> (sfid-20080212_112525_823367_01B716C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xfL7AKRyrqLXqQ0cQCK7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> true. i was not aware that the beacon timestamp is taking PHY delays into=
=20
> account and wrongly asumed that the RX timestamp should always be a bit=20
> later.
> (which is also what i saw on my atheros hardware: we usually get the RX=20
> timestamp about 60 to 300 usec later than the beacon timestamp, but it's=20
> quite likely that we have not calibrated everything 100% correctly.)

Later actually surprises me, are you sure it's not earlier? If
everything was calibrated perfectly it should be 192 usecs earlier (24*8
bytes at the most common 1mbit beacon rate).

johannes

--=-xfL7AKRyrqLXqQ0cQCK7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7FsQaVg1VMiehFYAQIt1w/7Beb4CQMYnsq/WsaIi3z4TOF3zKVE+kSr
PpjRUdAaj0WYzYOC6PgRpqAqencWorYd2u0nPrcYGlWsJMudO7Li49nTTJjy8rNu
/9jcfBr9n99TyiUAvedFzgCNeZUcgTQG+OFiNcW4Y9upg44GlgoE20/8iR/urfGZ
Lwea9qYVtI4tt1u5BS58ld8YviISv6mrTlyH4VdNG3e4jxW3Ch2FBmXNSXtfzQWv
6NW67a9yRXpfWVltEZlMEvVghc1ewP/8iWxsXOt8OuBhmfnmRBY7PQ1+2y+1qhDC
hHCoc5v1+IY2JwdPyW/nKzhngtwmIp3H94aO5zF9lr+fSyHCozDo5lvuO9KCdcGh
VWHtVhslpkshBywe10VDjLauF80T0VS9nWN4AryGIHhqPHFLvFPEU6FGQAe8tOyR
4H6ynxaagJhixEpeLfjmSyLnjJEo+XcEkxNpCCxH1eiEHvD/98kCV6QkFj5/GFk8
7USy1zg1swa4CNPITFo+++nhoCvcbZos4UY7/uBO6O1k4DggbMqZ2c6nEoW7/Q5a
QjHCys7lm/m/ed1c4Uo3qEmUhz8F0bQTJ6fTI/GJA4UIA0QhomqjEJLGA/qEa0lN
VFVnDukhXCUIjBcb8ekV8cE2u3KrYfg6wcR/4ZcUVM0n1YomzcngUmobbOImJlTM
Ga6yLHecKlE=
=I4su
-----END PGP SIGNATURE-----

--=-xfL7AKRyrqLXqQ0cQCK7--

