Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbXCELYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 06:24:31 -0500
Subject: non-promisc monitor interfaces [was: Re: Question about PRISM2  header rate field]
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200703042210.52534.flamingice@sourmilk.net>
References: <45EA9E39.6080706@warmcat.com>
	 <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>
	 <200703042210.52534.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nHGDtGUuuP5RsQcD5pAt"
Date: Mon, 05 Mar 2007 12:24:03 +0100
Message-Id: <1173093843.6131.49.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nHGDtGUuuP5RsQcD5pAt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-03-04 at 22:10 -0500, Michael Wu wrote:

> Note that modifying the management interface to do this is possible, but =
it=20
> would break hostap (and probably wpa_supplicant w/ MLME). Doing packet=20
> injection on monitor interfaces instead is safer in that regard.

I just thought about monitor interfaces unrelated to this. We really
should allow monitor interfaces to switch between soft and hard monitor
modes by toggling the promisc bit so that you can have a soft monitor
interface (to see what's going on between you and the AP) without the
power penalty.

johannes

--=-nHGDtGUuuP5RsQcD5pAt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6/3T/ETPhpq3jKURAmbkAKCMkJ9d4GwEm4UEfhJyMRxcq+G3ZgCeJr2E
A8jIOq/gj7+a/LClm4Qv2Tc=
=Jl3/
-----END PGP SIGNATURE-----

--=-nHGDtGUuuP5RsQcD5pAt--

