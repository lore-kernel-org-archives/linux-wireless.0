Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYLSNRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 08:17:37 -0500
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP
	as pairwise cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linux-wireless@vger.kernel.org, Jouni.Malinen@atheros.com
In-Reply-To: <1229692235-21734-1-git-send-email-vasanth@atheros.com> (sfid-20081219_141244_167603_2DBD43AD)
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com>
	 (sfid-20081219_141244_167603_2DBD43AD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zq6OKF6efyUp5WnrzKdS"
Date: Fri, 19 Dec 2008 14:17:34 +0100
Message-Id: <1229692655.3601.74.camel@johannes.berg> (sfid-20081219_141741_272077_E1D25CC2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zq6OKF6efyUp5WnrzKdS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-19 at 18:40 +0530, Vasanthakumar Thiagarajan wrote:
> IEEE802.11n does not allow TKIP/WEP as pairwise cipher in HT mode.
> Connect in non-ht mode if either of these ciphers is cofigured as
> pairwise.
>=20
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/mlme.c        |    9 ++++++++-
>  net/mac80211/wext.c        |    5 ++++-
>  3 files changed, 13 insertions(+), 2 deletions(-)

Needs to touch cfg.c too, I think? I'd also prefer to avoid using the
wext constants throughout mac80211.

johannes

--=-zq6OKF6efyUp5WnrzKdS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJS57rAAoJEKVg1VMiehFYXooP+wdEKUXqYTEB+w2qBY1g+iQn
E/yR6E0AexvI57Y+oRfc3KQK3VTMQlpL/I9ZnjbYzFwC2WQcUz/5FOAizeB1TZMX
ORTFztFZpJWOgtSD4qPUcQU+VhbhihZQACdosNkx1+GtQFzDiYpITaAl1AtIT3kH
E7ucZy3KV8vw8i8H1XSJPlI8a0xRfN9nG6qAiNaxEZACLg0r+xIorlT/o2yWs+oV
fzvEnVLadd9yV13n27xRrTaqLx6kn+tK5SA19vEZZdXgONuMtnPaRLEqWLElM/Ms
FPB+6UkBR2/rt6nKmU1lxrtH/l87vi7L/icWrO9y86ezw8S/ToISm4dEFQEB374L
ER2SeKojdC8jim0ldGDmyb9Gk3NSq7Fd6DxBKILLo1fC9E0iON2V1EL206gN8Re1
3Oou9joshGO8TbWsplbE/e8y4+FWvnfpWfvf/NjxYpRy6TF08hL/vG3DZ8Erh4iU
vcXAu8lFXI0y2+WJZYHPlqMxb5bnb9gyNrnwuAGqqVtaZSrzFYs7FzwUvW3P2qNI
8KuWV1ZmD1qs9L5eHv1G8qSad+HqCn61B53AqX3nybnJY/Jxjcm5YGLJByNWLffa
nGnB2V1Ku15UxYAdFkj1Y6ez7lycn/nEuH61wJKJEE0YhH5Gl8VEGX0hOvx9Q/nZ
se+c6rBgimRqZ/7xokUy
=yXPY
-----END PGP SIGNATURE-----

--=-zq6OKF6efyUp5WnrzKdS--

