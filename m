Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbXHQLi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 07:38:28 -0400
Subject: Re: [PATCH] Add iwlwifi wireless drivers (resend)
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1187350641.23489.172.camel@johannes.berg>
References: <1187328536.5763.137.camel@debian.sh.intel.com>
	 <1187350641.23489.172.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-blZ3chBGhGSZ1yvTTvuJ"
Date: Fri, 17 Aug 2007 13:41:11 +0200
Message-Id: <1187350871.23489.175.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-blZ3chBGhGSZ1yvTTvuJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 13:38 +0200, Johannes Berg wrote:
> +	  See <file:Documentation/networking/README.iwlwifi> for
> +	  information on the capabilities currently enabled in this
> +	  driver and for tips for debugging any issues or problems.
>=20
> -ENOENT. It's not in wireless-dev either, has it been written at all?

Ah, found it in iwlwifi.git, but it's mostly a list of TODOs and
documentation that only applies to the out-of-tree version, except for
the legalese.

johannes

--=-blZ3chBGhGSZ1yvTTvuJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxYlX/ETPhpq3jKURAqgGAKC3dGwvmNr6W9nDZ6j271AUS9Wy8QCeINLP
gPwyexLiIqoHUGfzkpYsZFc=
=35Bv
-----END PGP SIGNATURE-----

--=-blZ3chBGhGSZ1yvTTvuJ--

