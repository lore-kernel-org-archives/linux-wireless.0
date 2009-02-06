Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbZBFUoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 15:44:11 -0500
Subject: Re: [PATCH] mac80211: Remove TSF atomic requirement from the
	documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <87fxirpe1q.fsf@litku.valot.fi> (sfid-20090206_202141_993466_0DCBA166)
References: <20090205165834.63840@gmx.net>  <87fxirpe1q.fsf@litku.valot.fi>
	 (sfid-20090206_202141_993466_0DCBA166)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N2qx6GzmzR+KmJW1PZRS"
Date: Fri, 06 Feb 2009 21:44:07 +0100
Message-Id: <1233953047.4175.27.camel@johannes.local> (sfid-20090206_214415_769861_16C51014)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N2qx6GzmzR+KmJW1PZRS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 21:21 +0200, Kalle Valo wrote:
> "Alina Friedrichsen" <x-alina@gmx.net> writes:
>=20
> > The atomic requirement for the TSF callbacks is outdated. get_tsf() is
> > only called by ieee80211_rx_bss_info() which is indirectly called by
> > the work queue ieee80211_sta_work(). In the same context are called
> > several other non-atomic functions, too. And the atomic requirement
> > causes problems for drivers of USB wifi cards.
>=20
> Atomicity requirement also creates problems for SPI based devices, not
> only USB. So I strongly support for removing the requirement.
>=20
> Unfortunately I don't have time to review this, though. Sorry.

It's ok, I took a look, there's no such requirement (any more).

johannes

--=-N2qx6GzmzR+KmJW1PZRS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjKEUAAoJEKVg1VMiehFYVZsP/31krx770ICqpsmq+1s8sd77
rECYyOdWatxWNAlw96KaJr0TT35tlLc7brUPpJEoIN/iW2u4yiOnyuwwqicK7fla
Es7YTija5zwnG5DFfFXYFQ/WUQHdws7hWCwFV8wcDm1n6nt7mgYJmNUwJf5zJa3p
eYUql8BsTX+ztt/Y9PDcPd6BGvN9TRampKqy2YGAXAJkPdn/TGlhWgBLNWVeUmo3
YSDTJZwq0CRbij4LvyA8zJMDYC0/krqJTdbHeQwWoFulzvC72BCHn+s/e89trsbg
8XcUCU0IrnGElQQxckZdBLKegQQr96ulVKw2DHNxxoZXWDexDZnJ29s5IYW/uGWC
3vtbNDYmudc7O3nlldXRwGPUOHfjgI94dPzH96LFhfyMzoP8AbyvdmgVKWivNsEl
JiCzD/KNdrL9qBUnBUbqqfK+62S/TT7seGrjN4cv0Z9OIRrM/bEZG7IkjCrzRgnM
jqukmyikUc/Iwepe1Qiit5YySe/MxkA/lOUOF1mc62GhkyyZSr6svvoDFvq0fAZo
8FeR/Yc0Q6MiNmJTAxfRRzOlHL9KXsf/vOgN92zGMwI8iAaFX0XKkLBjxLWgtxlq
Tb+oMKH3cXkmhsOPJMi6S1nB6IFMe4xqrIA/+gCcY/U8l1gm0lQr7VnQSv4jzBIw
7SOPY1ENJbSdTrX+TzJV
=DanH
-----END PGP SIGNATURE-----

--=-N2qx6GzmzR+KmJW1PZRS--

