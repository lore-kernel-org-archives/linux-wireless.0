Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYLGMOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 07:14:34 -0500
Subject: Re: compat-wireless-2008-12-06 and no member named
	=?UTF-8?Q?=E2=80=98requeue=E2=80=99?=
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081207110349.GA11803@gandalf.dynalias.org> (sfid-20081207_125256_357288_A3A15719)
References: <20081207110349.GA11803@gandalf.dynalias.org>
	 (sfid-20081207_125256_357288_A3A15719)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NgFKl9NduSj1OZab37n5"
Date: Sun, 07 Dec 2008 13:14:23 +0100
Message-Id: <1228652064.22164.4.camel@johannes.berg> (sfid-20081207_131453_953889_499DC801)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NgFKl9NduSj1OZab37n5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-07 at 12:03 +0100, Norbert Preining wrote:
> Hi all,
>=20
> (please Cc)
>=20
> I am trying to compile compat-wireless for 2.6.28-rc7, but it bails out
> with:
>   CC [M]  /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.o
>   /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c: In function =
=E2=80=98ieee80211_handle_filtered_frame=E2=80=99:
>   /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c:449: error: =
=E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=E2=80=
=99
>   /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c:451: error: =
=E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=E2=80=
=99
>   make[3]: *** [/src/wlan/compat-wireless-2008-12-06/net/mac80211/main.o]=
 Error
>=20
>=20
> Is there a way to fix that? Thanks

No easy way, no, but if you're using .28-rc7 anyway why not just use
wireless-testing instead, which is wireless + .28-rc7?

johannes

--=-NgFKl9NduSj1OZab37n5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJO74bAAoJEKVg1VMiehFYba4P/0bT3L0CQhFFVAuJSxP8Pp+t
Gu25HyaiIzW4uWxu1+wytGCE5SPA5j6j7S0dDSl1VZ293xcm7KKH6y9LwADEjrCe
mpgVtnjvjxdt4/7B8MYpeOTkzAPnZTWACg+BkYBdVdtPpPssYaynLGsoidJ2ixLO
QQguMRb8mtudj/LNOvYDEwXQ5e9l1zXm1jKX7Lus30WDXVpABBXlLoxz/86aVOl2
AtFLSS24Bir287T5VULDqz3Xgym0jB971B7VRDZoe8BzK6OjrD4xTa9Coyy9ydj4
Cu2TRAkOMgJerPGD5Ra0+DpfIxRPfNOIF2koNQOf15Y9/5wt2yfVCfkZORN1Bth0
OhSG73M6oKSIkzr8rw9VY33S8H/kSPhl1ky8u0tb/tskrLt3GW+J20agx2yENgtP
eT4RHYaLmoaD6y8w22J4nWNLp9KcnK8k5l2nZwmLW9dWLXlkEvHJ16UMIlEQyTwP
V4r9MqRkR5O7Lyu5N4niH8f+MDu20qjj3ubmp4O69kKxlvE8rAMWZQAIx2SvMO5G
moknrr2BKC+r7xRfs7KpaV711Jnrkq3nkhRtttch6R2WCneRjdKONPewA+sDmPFd
5hkbp9VfizmVe+4625Rc7l9O+0s/bQnCuNT5GsB0/4XQTUFTp3EFImi2Ee8n31QP
15z3ge96OOiGfVkDsgJJ
=2jNv
-----END PGP SIGNATURE-----

--=-NgFKl9NduSj1OZab37n5--

