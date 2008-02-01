Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52973 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbYBAQpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 11:45:41 -0500
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes
	patch
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com
In-Reply-To: <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com> (sfid-20080201_125231_199064_27B09740)
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 <1201869970.4188.24.camel@johannes.berg>
	 <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com>
	 (sfid-20080201_125231_199064_27B09740)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/Olgf96Ig0V2fpL9LF6c"
Date: Fri, 01 Feb 2008 16:20:58 +0100
Message-Id: <1201879259.4188.31.camel@johannes.berg> (sfid-20080201_164549_573363_0D6C8082)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/Olgf96Ig0V2fpL9LF6c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I guess you could add a helper function that allocates a channels array
> > based on a frequency range.
>=20
> This is true but also it would be nice as it is the end points which
> drivers may want
> to access every now and then. I think its worth the few bytes.

I'm not really worried about the space that needs, but I don't see why
the wiphy would need that information. Couldn't you keep it in your
driver's per-hw structure as it is? Would cfg80211 be required to keep
them updated according to regulatory rules when the allowed channels
change? I'm much more worried about all the code that would result in :)
But since you're not doing that right now anyway I'll just wait and see
what you come up with ;)

johannes

--=-/Olgf96Ig0V2fpL9LF6c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6M42aVg1VMiehFYAQJg5g//Rhrikppcd4JA/Aqh7cDA3gc+xfG3fWoJ
lRVeTlMiyUJtoiQP9rkkIjPaZAwWV0wxRlnezIKv97WDQdyCs05PwDeVesAORsh7
poWUe/kG9SCVqQOO1GAGr7JVqWL2s0rvLbZNMPYZgTym+H/+4ZBLmWKtuiW7JOJg
G5zGL4Irb9uQXrwJeOz6uVtnlP1fQ9hsLpdn57s43HLYhGfwbia4wGh31q92wMWR
rX0+qtl8ks3cd6K+80I9s+Yu5lDsTzejX/PF4mMZ+cCuQ93WbAuo1AYrDrP8oPDT
WsFkqlCIl+/IgT21VpMdlBkChyIRgkeqpBYuQ0Rdw5pKLXDjZtKGcVkS45DTgaKv
iaP8YAniNgqxtFwofESj22NxawzFHx5NYg+TBs2tvyfB+04J+JE29Xut4z0M5ZGp
TIr/VgVzbBNr7rvsfs3GQUpeFJ3RrtAK5mxNa0OdTjSP/h/m9C0+KpDiBfWsoREd
QZCJdY9KuClQiqLt1AsFMBY3m7JGo/Pn0fKNHe7SCiFQ2IwtNtwINj2jgmISTJL/
LLSLHEcNWvyuXcsxk6X6JtjIwxfa3BrL5VK9DyjzZr/vVdJkO9d1ypKgGRMRA/qQ
NitTEPWasZJQz6K6+sf3VZidkLHqZwNxgeg6YgSJ4wyeMdClFe1nfpJXEC3mU6kI
TyKFGJenBDg=
=AOGt
-----END PGP SIGNATURE-----

--=-/Olgf96Ig0V2fpL9LF6c--

