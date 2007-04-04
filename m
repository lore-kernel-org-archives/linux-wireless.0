Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbXDDWhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 18:37:16 -0400
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
In-Reply-To: <200704042222.l34MMYCr009965@cvs.openbsd.org>
References: <200704042222.l34MMYCr009965@cvs.openbsd.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QcNqLJ/8nyxFv2iT+ixO"
Date: Thu, 05 Apr 2007 00:35:51 +0200
Message-Id: <1175726151.7388.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QcNqLJ/8nyxFv2iT+ixO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-04-04 at 16:22 -0600, Theo de Raadt wrote:

> > "What if Broadcom decides to take our LO measure state machine and
> > put it into the original driver? (The Rev Engineers told me they have
> > a very different weird solution for this in their code).
> > I really don't want to see this happen."
>=20
> For the record, I want to warn you that you CANNOT COPYRIGHT
> A STATE MACHINE, which is what the above sentence implies.

That was in a different discussion, quoted out of context. Another part
of Michael's email gives some context:

> bcw_phy_lo_g_state()
> This exactly matches bcm43xx, although the specs only have an abstract
> description and diagram of the state machine.

Hence, it'd be only fair to say that he did, in fact, talk about the
expression/implementation of the state machine.

johannes

--=-QcNqLJ/8nyxFv2iT+ixO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGFChH/ETPhpq3jKURAiCcAJ9XlU97+II+ZW6h0yDj3u+3LI8yxACfcnwd
JQQn5MwsHExwUrHsaCEGLCA=
=6t5W
-----END PGP SIGNATURE-----

--=-QcNqLJ/8nyxFv2iT+ixO--

