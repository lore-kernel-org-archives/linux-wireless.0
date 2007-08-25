Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151AbXHYH5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 03:57:24 -0400
Subject: Re: [PATCH] b43: include FCS at end of frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200708241512.44463.hs4233@mail.mn-solutions.de>
References: <1187953310.24933.19.camel@johannes.berg>
	 <200708241512.44463.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YE8llOdh506ncGs50mbE"
Date: Sat, 25 Aug 2007 09:58:22 +0200
Message-Id: <1188028702.9529.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YE8llOdh506ncGs50mbE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 15:12 +0200, Holger Schurig wrote:

> You must have a very different tree to wireless-dev, branch everything.
> According to git blame, since 2007-08-13 the piece of code there looks
> like this:

After my patches, yeah. I screwed up, shouldn't have posted this yet.

johannes

--=-YE8llOdh506ncGs50mbE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGz+Ee/ETPhpq3jKURAiz1AJ0ReSqY88rkBP/n8Xui1ZiHKH+w5QCfXqLk
OJlbGUDQOyvxvb0ilzmqtzI=
=vRy/
-----END PGP SIGNATURE-----

--=-YE8llOdh506ncGs50mbE--

