Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966033AbXBOQQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 11:16:36 -0500
Subject: Re: [PATCH 06/10] d80211: update for wiphy api
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20070215144258.819563000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
	 <20070215144258.819563000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gxGzeTmrDV5RRXOjbSfM"
Date: Thu, 15 Feb 2007 17:16:32 +0100
Message-Id: <1171556192.5220.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gxGzeTmrDV5RRXOjbSfM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

As a follow up to this, I may post a patch that moves all the sysfs
stuff d80211 currently does into debugfs where I think most of it should
actually be. Then we can decide on a case-by-case basis which ones
should really be part of the userspace API.

johannes

--=-gxGzeTmrDV5RRXOjbSfM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1Idg/ETPhpq3jKURAnrIAJ4xqY58Kg/57eYVJP4IxmB87/G/jgCgus1M
IcqvTHbqF6KHBAN45C2m0MI=
=bTHP
-----END PGP SIGNATURE-----

--=-gxGzeTmrDV5RRXOjbSfM--

