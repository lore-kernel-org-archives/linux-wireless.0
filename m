Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYDMKLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 06:11:47 -0400
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
In-Reply-To: <4801C4FF.5060606@archlinux.org>
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
	 <200804021932.26046.IvDoorn@gmail.com> <47FE8FAD.9020802@archlinux.org>
	 <200804121246.44236.IvDoorn@gmail.com> <4800F76C.7000801@archlinux.org>
	 <1208072495.4111.10.camel@johannes.berg>
	 <1208074049.4111.18.camel@johannes.berg>  <4801C4FF.5060606@archlinux.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ttD+rT+WOdc8eMBcjVmE"
Date: Sun, 13 Apr 2008 12:11:35 +0200
Message-Id: <1208081495.4111.32.camel@johannes.berg> (sfid-20080413_111200_782891_C56BC554)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ttD+rT+WOdc8eMBcjVmE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I figured as much from the original commit message. So rt2500pci works=20
> properly when the use_short_preamble has the wrong value, and breaks=20
> when it has the right one.
> By the way, 2.6.25-rc8 was the first time that rt2500pci was ever fast=20
> enough to be usable at all for me, so the bug you introduced seemed to=20
> be the fix for my speed problems (which is odd). My guess is that=20
> rt2500pci treats use_short_preamble wrong.

Even using use_short_preamble wrongly shouldn't give much of a drop in
network speed. I fear there's another bug. Is your AP even
short-preamble capable? Maybe that's the problem, your AP isn't
announcing short preamble but we're enabling it by that code? I haven't
looked in too much detail yet though.

johannes

--=-ttD+rT+WOdc8eMBcjVmE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAHcVqVg1VMiehFYAQJMDA//WzRYmAkg8CH3mQgYZfCzspxnQKzArf/V
PSHHReNRqlL/YJ2D3Hl+pAr7wZAvYfiLvv8IOQUFkUJZ3woV77a6som9R4k3yvsU
VOk4c3BhNjC+DwrwisTLvweCptN3i+BETlTJQiW/fiWpHTk7AovjtGN1jXWX0+uE
bYDTX7VGG23taxIZSXt0sITIzfOJei54R5XmtRj1eWHx9acRfDsHINEkLQWKzUJ3
r7nl7BpLLFb9tsIHk3ApU5QGPwcjsI8QkZaOl/2uZ0BoVzQG0eJpBhOOXolpywVA
dX6/RNpl5jMQEiiqZlpvSDtsCfm22NZ4VxyS6sR6TKmalIZlv8wVS6hK1rwq2h46
fvNLivXAyXHOVBi0QJ5PcSzZybnWe+4xG6Vc/M6IqjIe75nP3bka/lvNXA3JvodZ
8ZLkaoBW5N/xp28AeyrkFLMe46OXgcxxY5kRT3ZUPaxBsnn303zXq+upHx9UyLU5
3RWQNwEVsKbBTgEckzNfJCDt8A1feU7SmgqN3jEGtbYlksixhWRlWzBWCt3VMnN4
o1GR8UfxwMOeBAfZMehRfCCNPYQ5xMDu40FTrMyx9yhMmoGku8LFV1x/wXVmIif0
BHtusoeOU6qoqutLozMmOEOYM+Y0vKwN4W7BUvK6fsGURayoVNl1kv3q7c0ZzJzU
JB/q2Pv5Rsw=
=vz5P
-----END PGP SIGNATURE-----

--=-ttD+rT+WOdc8eMBcjVmE--

