Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbXHXMpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:45:52 -0400
Subject: Re: [PATCH 00/15] more key handling updates
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070824122705.549190000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HyV5s6SOx4RPdcNtr1wv"
Date: Fri, 24 Aug 2007 14:46:37 +0200
Message-Id: <1187959597.24933.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HyV5s6SOx4RPdcNtr1wv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 14:27 +0200, Johannes Berg wrote:
> This patch series updates mac80211's and cfg80211's key
> handling and adds some documentation (more to follow.)

Looks like this will break the new drivers (ath5k and b43legacy)

johannes

--=-HyV5s6SOx4RPdcNtr1wv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGztMt/ETPhpq3jKURAuMgAJ0UeB0KV8JHFOG+NWCgEkMWDm56ggCgoTZK
pM9Ynzewc6a0jPI5Zm+rLT8=
=+fLO
-----END PGP SIGNATURE-----

--=-HyV5s6SOx4RPdcNtr1wv--

