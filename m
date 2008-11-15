Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYKOBvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 20:51:49 -0500
Subject: Re: [PATCH] mac80211: make Minstrel the default rate control
	algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, derek@indranet.co.nz
In-Reply-To: <1226713493-4449-1-git-send-email-lrodriguez@atheros.com>
References: <1226713493-4449-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Rq6myK0iDPIs0c89uE8/"
Date: Sat, 15 Nov 2008 02:51:41 +0100
Message-Id: <1226713901.4120.44.camel@johannes.berg> (sfid-20081115_025154_552139_9AD650C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rq6myK0iDPIs0c89uE8/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> =20
>  config MAC80211_RC_PID
>  	bool "PID controller based rate control algorithm" if EMBEDDED
> -	default y

don't we want to remove that if embedded there then? otoh, who really
cares...


>  config MAC80211_RC_DEFAULT
>  	string
> -	default "pid" if MAC80211_RC_DEFAULT_PID
>  	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
> +	default "pid" if MAC80211_RC_DEFAULT_PID
>  	default ""

I don't think that matters :)

johannes

--=-Rq6myK0iDPIs0c89uE8/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHispAAoJEKVg1VMiehFYyVcP/0AzpYlgzNjmjqEgIHp3Xp2X
rG/aaj1XQJY+tSPZhU/Xlb2AigXJiM082ONs16IgE8xW0IF6kvi5s0FiIx9Y8+Mt
a0CijahC5d+/KnP03cmwnSiFfwA5e1mPsaHsjsziQEzNPmEEjui6jxw56yKSjSD0
vxWDDRUiRCruDpZc5fWHOeIbZOBxnXnJKKd5oTsje+tnAJXVgiemTgMXb3l1tBpP
1EtRR4gypjn9fka09YiC+Xq4/lQElXXF8nMZCQTCWfdttHa+lOiPPIOVkpTCasYq
5kPPW9HOe+HP15caCgfCntjJcxkv4eMtjSRMy890wJKoSLYdndtZKc+eKgIF0pQa
OKLakNQ3mrFV+mzjGb8mI8cKEpn1ggOWmsyQbV9AFXtBTSBb3F0ChONt82BUq3GG
tsiDbwV6w2ItSaK8P6yj195I6bGkCn07CP74DJKRzKlnKzHtI+tfT15gcpoluY1O
YjQjqaY1NUoiFk4UfPdFPL/CgtvFzryoHCyOHJ/xoraTLMtuzblAa8GvYP6Dfxtq
QLuSWDTc+MiOHHRkpEKNsFjBJfVu0I3Wrkp54F0yYL147pR4v1l1npcUE9iI1i17
cGwRZHj+mZVE6HZtRqcgCl+BrxrcuqSsvoobsLyiP6oCXhGR3H50F8gHsTls3rdM
MfEAndg9KEHMmmI0mYlr
=VV9g
-----END PGP SIGNATURE-----

--=-Rq6myK0iDPIs0c89uE8/--

