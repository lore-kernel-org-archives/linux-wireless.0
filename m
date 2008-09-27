Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYI0NRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 09:17:04 -0400
Subject: Re: wireless-testing modpost failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <2da21fe50809270534w71609ffdjd1177384547ee1b@mail.gmail.com> (sfid-20080927_143500_548757_610B3BAA)
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
	 <1222457416.3798.25.camel@johannes.berg>
	 <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com>
	 <1222504695.3798.38.camel@johannes.berg>
	 <1222507225.3798.45.camel@johannes.berg>
	 <2da21fe50809270354i4d28335vfe166c166d33dc7@mail.gmail.com>
	 <1222516090.3798.62.camel@johannes.berg>
	 <2da21fe50809270534w71609ffdjd1177384547ee1b@mail.gmail.com>
	 (sfid-20080927_143500_548757_610B3BAA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kX5Vmb50ZtrcfO+hjMzE"
Date: Sat, 27 Sep 2008 15:16:57 +0200
Message-Id: <1222521417.3798.64.camel@johannes.berg> (sfid-20080927_151718_142594_834FC964)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kX5Vmb50ZtrcfO+hjMzE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-27 at 14:34 +0200, Davide Pesavento wrote:

> > Ok, strange. I suggest we simply remove the debug_noinline from
> > ieee80211_rx_h_mesh_fwding then, want to do a patch?
>=20
> Why not putting an #ifdef CONFIG_MAC80211_MESH at the beginning of
> ieee80211_rx_h_mesh_fwding instead?

I'd like to avoid #ifdefs wherever we can because that way we get to
compile most of the code even when not having all config options on,
which helps when doing patches.

johannes

--=-kX5Vmb50ZtrcfO+hjMzE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3jJFAAoJEKVg1VMiehFY/koP/3xBo1q+eEEQ0IS0oIgPibnd
PEBrGZGTMSVCqa+tV1UEe64aQ/vpNzS1zPkmrNqjWsEX6fA9AsheQkEzZ7T+I1kJ
wOhvTMRPMDI3LBx0IkefuHUt9PeE1JtMg5Z18eWSgDrnQ4GZSSwaFgp++VeoCws+
NsxmoLhSC5jNR2BThvjLxtJWlmPjx1NT9PPDSgCArA97Eq9cFpGNAIdAbVNSxeji
KEPu5jDTbDgGLjNX/90VIPRO5PMGB7lfKfcpFwQWNtir2B7/ohgv706H4vp6sVps
L7ikrX7WTvyAqNtjGiVZD6hK35y1o4xBm0q2t9qQYrYsuN1UwypUTTS5Sp5UG9bs
1Q3M53xvWdeMAk1BKH3xT9fOPw3AkDMiw93x7KDYsqrFrY4h6QXV+W3Hw6HBwFCy
gNXNuEkmKtgxV58WnpkwFiG7o6COpjvFJEbYHT9gyZWo5hQtlvnm7sSzNoIBgGqn
N6I72J0Bka5lRfNLKBCCX5b64E0/QjGcffd0PNNE47w9nFmMhInRJJPpKEIopHzL
KNcHyW/PlF1eKaEbP+/x+kSqbx++hotwBSy4flIzNhKaJ2H+YaaDrGNE9/jGBq92
j3niXH4zS7YfhD5/rY29R73I8z6ZT7WEhI5t6Tz8RYJqr+1ZHWTZRlYFudiqYWWS
0tRmXHMUMHecD1EgyWB3
=DqH0
-----END PGP SIGNATURE-----

--=-kX5Vmb50ZtrcfO+hjMzE--

