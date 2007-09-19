Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbXISKUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 06:20:38 -0400
Subject: Re: [PATCH 1/3] mac80211: rename ieee80211_cfg.h to cfg.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709181742.21305.flamingice@sourmilk.net>
References: <200709181742.21305.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xbAm1q8xFXqUUKqHCRtE"
Date: Wed, 19 Sep 2007 12:21:58 +0200
Message-Id: <1190197318.4414.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xbAm1q8xFXqUUKqHCRtE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-18 at 17:42 -0400, Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
>=20
> Might as well rename ieee80211_cfg.h to cfg.h to keep things consistent.

Maybe we should just get rid of it and put the one thing into
ieee80211_i.h?

johannes

--=-xbAm1q8xFXqUUKqHCRtE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8PhG/ETPhpq3jKURAuFdAJ9LnBreGeuaMa+A1lWqRqXC4wNjMwCeOY8j
JTZkCBqsntCKRFlkvwa3t0U=
=LCRw
-----END PGP SIGNATURE-----

--=-xbAm1q8xFXqUUKqHCRtE--

