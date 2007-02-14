Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbXBNTEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 14:04:23 -0500
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Joseph Jezak <josejx@gentoo.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <200702100655.51495.mb@bu3sch.de>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
	 <45CCCAE1.9080901@lwfinger.net> <20070209213239.GA11650@srcf.ucam.org>
	 <200702100655.51495.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rEspaolx7Cr6qpw+rgR+"
Date: Wed, 14 Feb 2007 14:18:10 +0100
Message-Id: <1171459090.11116.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rEspaolx7Cr6qpw+rgR+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-02-10 at 06:55 +0100, Michael Buesch wrote:

> It's likely that old cards still work with v4 firmware,

No, it's absolutely impossible. Rev 2/4 cores have a totally different
instruction set in the microcode.

johannes

--=-rEspaolx7Cr6qpw+rgR+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0wwR/ETPhpq3jKURAmfzAJ9AhQiN8fAYEbbUGc3rZnh3pJz8gACgi67r
cysrzMguMMuwFKfOg7Bkhds=
=0F/a
-----END PGP SIGNATURE-----

--=-rEspaolx7Cr6qpw+rgR+--

