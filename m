Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYGXLq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 07:46:59 -0400
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	francois.valenduc@tvcablenet.be, akpm@linux-foundation.org,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, netdev@vger.kernel.org,
	jussi.kivilinna@mbnet.fi
In-Reply-To: <1ba2fa240807240435g36daa80at254144afffc39c32@mail.gmail.com> (sfid-20080724_133550_701095_354A4111)
References: <4887550B.2070704@tvcablenet.be> <4887555A.30605@trash.net>
	 <48875B8C.2090800@trash.net> <20080723.142147.61941255.davem@davemloft.net>
	 <48884451.1090703@trash.net>
	 <1ba2fa240807240317g15f6ba84h91b513cce75975e9@mail.gmail.com>
	 <48885743.8030505@trash.net>
	 <1ba2fa240807240435g36daa80at254144afffc39c32@mail.gmail.com>
	 (sfid-20080724_133550_701095_354A4111)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FQSmg9yf1gLJUgJ+FKQ6"
Date: Thu, 24 Jul 2008 13:45:26 +0200
Message-Id: <1216899926.13587.51.camel@johannes.berg> (sfid-20080724_134718_398078_AC17950C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FQSmg9yf1gLJUgJ+FKQ6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-24 at 14:35 +0300, Tomas Winkler wrote:

> >> Isn't this time to make 802.11 native?
> >
> >
> > You mean by making these things real skb members? I hope you're
> > not talking about the entire 48 bytes? :)
>=20
> I mean elevating 802.11 header to 802.3 level. Not doing 802.3 ->
> 802.11 translation where not needed.


We've discussed that over and over and over and over again, and it's not
going to fly since 802.11 throughout assumes that you have a two-address
data service to the upper layers.

Besides, making it 802.11 native doesn't help with the control
information at all.

johannes

--=-FQSmg9yf1gLJUgJ+FKQ6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiGtSAAoJEKVg1VMiehFYa/oP/3ADaXW8UwWpUa0U/+QH6Alc
zU2L+SbsVs5UcsN+yDHpkiIFlnljzm1iqqJCZR2QeonvrSWeLAJUrFBP3I0/SZjm
Vpx0czcVFjkUkpWt6ORmYXDAMaHk5w2pvsmCNno/7+l8jQCBr0TSTbiPjFIakUQ1
98JkAJMdrunZtze3HO8vWa0sRWvNlnJSe0SwIFAlgHBtf09OjQduvN3r05g767C+
GUZQEG1x2nLEql2yh6emwtZ4ukkMnQZ1gMbJsg7WOt/K498vYR4rvaxEh7QCVKqd
xNPm9Op62jQZJkY7sauHaMZXHjlpzSzy+MfOE3pgxtzaaWVvJbEFxVYfSNEPPkHF
FqDIYqO+9xJb+xxpyGB4wk5pgw/Wze1lD8e3gFv4ZT+JYX9QbYNiVpWfYhX18tlX
EU56karZokORizYj2LNc/iVeLeSohewuUIp1rqWLg74llAL1Zfp37cBKhw1Kgfms
6HnmyzBnemQVttbDHR4N7FwTt7qzBl56aeSDcqONymOWWrNu4F3Lk+P0SPwLQcni
ssPG7ralumgjnILy4QxL31dWbmrwMM8U2MATK0+IVvyh30yr1+578w5J1PBgrFkF
n4l5o6xzY2b56PFHdtM70yHcHuK5e4M3WA+SEsrQ/h4EmEFBL/Xf2l6AUunyNykW
TnMo90kdFEH2PE0wgqmY
=di0n
-----END PGP SIGNATURE-----

--=-FQSmg9yf1gLJUgJ+FKQ6--

