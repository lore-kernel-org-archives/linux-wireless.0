Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYI1Q0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:26:12 -0400
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com> (sfid-20080928_182426_075205_738DB644)
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
	 <1222618769.7064.0.camel@johannes.berg>
	 <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com>
	 (sfid-20080928_182426_075205_738DB644)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x0fM/al2e2ygUINKRWEQ"
Date: Sun, 28 Sep 2008 18:26:08 +0200
Message-Id: <1222619168.7064.3.camel@johannes.berg> (sfid-20080928_182614_922570_C55CAD75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x0fM/al2e2ygUINKRWEQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-28 at 19:24 +0300, Tomas Winkler wrote:

> >> This patch makes mac80211 able to send action frames when toggling
> >> (SM PS) Spacial Multiplexing Power Save mode.

> > Why is the driver managing the PS mode to start with?
>=20
> What PS mode, SM PS mode or traditional PS mode? Please be more
> verbose so I don't have to guess what you mean.

This was mostly concerned about SM PS mode so that's what I'm asking. I
don't actually know what that is anyway though, hence the question. We
keep adding API in mac80211 and nobody really knows when to call it.
Maybe you should (maybe team up with Atheros for it) write a "HT
hardware with mac80211" chapter in the documentation?

johannes

--=-x0fM/al2e2ygUINKRWEQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI37AcAAoJEKVg1VMiehFYk0wQAKoOGbUjJXhZr6iTaZjo6BJp
9PwVFXyH5FRyGDt5jThNVRWZKvqdi6Q6avVXrrv3xORxLWbyeXs0luPYV7niKFFv
tX0oxaPMbuRA16woJbTBAjlDou6YT346i+FOR8MiGZXRP5dgsQQE5p8od1eGI9ry
lFXR73UrAbT3gDPHGQgT2XgEVeq9a4nBsTilDI0h2bqZTp+Xtgvng6Yf6F/qoIER
35KJa5Gya2DATggfQhDyovWBnCJIjSQxB9Ll1RHvbSxXpeZVJgJhDThdancoBdqZ
OBUCVAdMBfJE4XPIwcdmZiyiJiMjehjjCfXQNyJhHls2FZJX6xgLPNB0SM2HAwt4
1Aiw+nrS0bvDYJx2WfcJ6VB8OWBfADCP8eTqh2hPHXUwaF5LRX4c2bzA7RNCj4bX
h4KnH71Aj+HdkyJinD6jyBerI1ZRSPiQK/cJwps7ei5KLmLPf8RWVO22jVi5Uj2P
OUj7Ci9kIpjJ/NK+dSUjUYFWP5xl+S5pVZUF/sC9lVNZXmu3p9VP21ZLICFEeaVS
0tvZPDWWoE9Syh7KNaIN68Cb9yig4iDL4oNRMSHYSDuLNoi0uAh8gxGKFLoAYfHD
YA4gIoVG/EWN41rAFk6V4tRvc6Me5SFwFn0U5svOsqLHHkVfC/A44MBCPRcm/wFO
LFVcqf1W9QAID7BeNvbY
=YIrS
-----END PGP SIGNATURE-----

--=-x0fM/al2e2ygUINKRWEQ--

