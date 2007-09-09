Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbXIJKaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 06:30:10 -0400
Subject: A-MSDU deaggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed salim abbas <mabbaswireless@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3ZpPd/mM9Ry4uIldsy2Y"
Date: Sun, 09 Sep 2007 18:15:26 +0200
Message-Id: <1189354526.4506.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3ZpPd/mM9Ry4uIldsy2Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

I just looked at the deaggregation code for unrelated reasons and
thought about it a bit more; shouldn't there be some sort of checks that
the 802.11 rules about identical addresses are adhered to to avoid
having rogue packets pretending to come from somewhere else enter the
networking stack? This can usually be avoided by using RSNA, but this
code allows one to easily circumvent this which makes us look pretty
bad.

Makes you wonder why they included full 802.3 framing in the
subframes...

johannes

--=-3ZpPd/mM9Ry4uIldsy2Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5Bwe/ETPhpq3jKURAhkVAKC3Pi72rbHJzlySO71czZpQY/VaJwCgscnQ
c+zrHfPPPQTbTN3w5AUYlm8=
=/k3h
-----END PGP SIGNATURE-----

--=-3ZpPd/mM9Ry4uIldsy2Y--

