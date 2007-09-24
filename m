Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXIXS7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 14:59:02 -0400
Subject: Re: [PATCH 1/3] Net: ath5k, make its own directory
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com
In-Reply-To: <2595810412809010611@pripojeni.net>
References: <2595810412809010611@pripojeni.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-POEIPMtGsY2rpgeD+Ij/"
Date: Mon, 24 Sep 2007 21:00:19 +0200
Message-Id: <1190660419.18521.278.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-POEIPMtGsY2rpgeD+Ij/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 14:39 -0400, Jiri Slaby wrote:
> ath5k, make its own directory

> rename from drivers/net/wireless/ath5k_regdom.c
> rename to drivers/net/wireless/ath5k/ath5k_regdom.c

imho you should get rid of the ath5k_ prefixes now.

johannes

--=-POEIPMtGsY2rpgeD+Ij/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+AlD/ETPhpq3jKURAhJXAJwLBbiWUFQjBAcG2CeCbCwaZEhtiQCeJJUR
L4yCoDVTYWEbiim5WletA/c=
=ekGr
-----END PGP SIGNATURE-----

--=-POEIPMtGsY2rpgeD+Ij/--

