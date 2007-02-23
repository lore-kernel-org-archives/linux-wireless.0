Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbXBWLWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 06:22:42 -0500
Subject: Re: [PATCH] d80211: optimise if_alloc() name creation.
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070222223941.7f637c2c@localhost>
References: <20070222223941.7f637c2c@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IAoMdObaisdcFkVTYgMT"
Date: Fri, 23 Feb 2007 12:22:32 +0100
Message-Id: <1172229752.3870.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IAoMdObaisdcFkVTYgMT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-22 at 22:39 -0800, Stephen Hemminger wrote:
> The code to do guess and check for creating a sub-device name is unnecess=
ary.
> dev_alloc_name() is optimized to do this already.

Ack, I thought this might be the case some time ago but then forgot to
investigate.

johannes

--=-IAoMdObaisdcFkVTYgMT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF3s54/ETPhpq3jKURAi9zAKCGoLjphIcXARjzHSjlhHSMbjc/1gCfVZzJ
EaH420ZK/Fv+oPe+K1mbn5c=
=tBR9
-----END PGP SIGNATURE-----

--=-IAoMdObaisdcFkVTYgMT--

