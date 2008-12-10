Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYLJPab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 10:30:31 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <20081210150935.GA10927@srcf.ucam.org> (sfid-20081210_160955_698729_A777A57C)
References: <20081210150935.GA10927@srcf.ucam.org>
	 (sfid-20081210_160955_698729_A777A57C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dnz9u2c/kYBdIOIiAzRN"
Date: Wed, 10 Dec 2008 16:29:57 +0100
Message-Id: <1228922997.15837.6.camel@johannes.berg> (sfid-20081210_163034_809928_AD62CC2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dnz9u2c/kYBdIOIiAzRN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 15:09 +0000, Matthew Garrett wrote:

> The final change is that I removed the code for changing the wireless=20
> state in response to the txpower configuration in mac80211. Right now, I=20
> can't see any way for this to work correctly - if the user disables the=20
> radio via rfkill, mac80211 doesn't flag the radio as disabled. As a=20
> result, the next time the configuration callback is called, b43=20
> reenables the radio again, even though the user has explicitly disabled=20
> it. I don't think any of the other drivers handle this case, so I'm not=20
> really sure what the best way to handle this in future is. The current=20
> situation certainly seems broken.

We're going to have to integrate rfkill with mac80211, but nobody cares.

johannes

--=-Dnz9u2c/kYBdIOIiAzRN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP+ByAAoJEKVg1VMiehFYwowP/AhNde/vOxaUwzLM1VTrCMAR
PVT1w50KCb9Gr3jEyZJHNAiSL9nEkah1dK4lH1OynqLDZoVHxYnlTC3+RenKtqjP
AAA63vu6qDMnZZxB2+qCMfUYhwpjsHU5+uZrsf0uuvJpRDxzNx6wFEZ0mS1colVe
NK2G+4ibipTG5ZuMB3DL+n76YhJsLYV0B61QfyKefpxYxFcVpJFx79PJ2irOn1rH
qH5prwwEVa4Wn7NBC7ObL3GalZhPcbZZPpB0XBXpYA54dChO6VdXTWXv1ABZxbBH
SwAIYhZckJC5VgjSHV3T4fp4THxOj7BkNr9mhf4JjWtOL0XafDkRjxi40PPWlT9w
w1sx3DzS576BZYivElqPgoqnbpvyVwsqmPOx/Q0XvGhoh+5W2g9JiwIAYsMbZjtF
2ROpNdWHLqE7pioEygZfZsE3G43zrYlvlpmgtbEfVALZF9WUrXE9+1XEm5vnoYCF
R78EYvLqpPNXu1slIFC8Yk6oFtBYMBsV+YKKWU3/FeGg8oqjnMVobSG2pB4Cq4a+
c7YGrM5TaoLP54PG//1f0GulmTkZT3BXtIH5M1w1Yklny9cqzbOC/U0VQM5ZoTNZ
E/ieFmj2UCDPV+QKCu3SMG+rE8BO4hhGa/Q7wwDdQVpdVJ2vUfq9/quSiTovJDuD
/uRiq5Drld9u0uzilGqd
=RSEc
-----END PGP SIGNATURE-----

--=-Dnz9u2c/kYBdIOIiAzRN--

