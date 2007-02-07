Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161012AbXBGNfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 08:35:21 -0500
Subject: Re: [PATCH] bcm43xx: Fix for oops on resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <45C9D2E1.7040906@lwfinger.net>
References: <45c8bd59.oamnvaNRMZvKoPBa%Larry.Finger@lwfinger.net>
	 <1170850549.6798.22.camel@johannes.berg>  <45C9D2E1.7040906@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dW6QAIV0t5HDZ8bF3dEP"
Date: Wed, 07 Feb 2007 14:32:30 +0100
Message-Id: <1170855150.6798.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dW6QAIV0t5HDZ8bF3dEP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-07 at 07:23 -0600, Larry Finger wrote:

> As you suggested earlier, a slow clock setting in the bcm43xx device may =
be the cause of this
> difficulty. If my laptop would suspend/resume correctly, then I could tes=
t various fixes based on
> that hypothesis.=20

Mine does suspend, but I don't see the problem...

> Since it does not, I think the band-aid approach is warranted.=20

Oh yes, I agree, having some hardware mess up will almost always crash
the computer anyway.

> A proper fix is
> still on my agenda; however, getting full data rates still has priority.

Sure. Thanks for all you're doing :)

johannes

--=-dW6QAIV0t5HDZ8bF3dEP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFydTu/ETPhpq3jKURAij5AJ926Vy+3KkRX+/OBFRO9cbSutuCFACfYiNq
kazZr+6i5YprEP/M5Ane0c4=
=uRTI
-----END PGP SIGNATURE-----

--=-dW6QAIV0t5HDZ8bF3dEP--

