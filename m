Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXFULCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 07:02:48 -0400
Subject: Re: [PATCH] mac80211: show transmitted frames on monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1182417915.10821.1.camel@johannes.berg>
References: <1182417915.10821.1.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WqQoIE06vqgvsq9X4xoE"
Date: Thu, 21 Jun 2007 13:03:53 +0200
Message-Id: <1182423833.10821.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WqQoIE06vqgvsq9X4xoE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hmm, another thing is that with hw crypto you'll see the outgoing frames
unencrypted, but with sw crypto they'll be encrypted. That's expected,
but I suppose it'd be nice to tell the program seeing the frames which
is the case, the frame control bit could be updated for example..

johannes

--=-WqQoIE06vqgvsq9X4xoE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGelsY/ETPhpq3jKURAuKcAKC7LDTmr0mp6iBeBrfI4NXaMucu3ACfcD2K
ZUcG35RoUV3vJ/n68l6i8Xk=
=Kmm3
-----END PGP SIGNATURE-----

--=-WqQoIE06vqgvsq9X4xoE--

