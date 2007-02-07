Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161273AbXBGMSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 07:18:45 -0500
Subject: Re: [PATCH] bcm43xx: Fix for oops on resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <45c8bd59.oamnvaNRMZvKoPBa%Larry.Finger@lwfinger.net>
References: <45c8bd59.oamnvaNRMZvKoPBa%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nIAeVNKkW8S0delCnSTK"
Date: Wed, 07 Feb 2007 13:15:49 +0100
Message-Id: <1170850549.6798.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nIAeVNKkW8S0delCnSTK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-06 at 11:39 -0600, Larry Finger wrote:
> There is a kernel oops on bcm43xx when resuming due to an overly tight ti=
meout loop.

Come to think of it... Is there any chance of fixing the actual oops
that happens in this case? I can imagine broken hardware or firmware
that causes this as well and we don't really want to oops in that case
either... That's why we have the timeout in the first place, to not hang
there forever.

Nothing against this patch though.

johannes

--=-nIAeVNKkW8S0delCnSTK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFycL1/ETPhpq3jKURAr3PAKC1GFxqEpU6pUw+vRwN5Cjnf1SIdwCfUu9L
iPcN5QVP51rRYtc8YwE3A7Y=
=cvY/
-----END PGP SIGNATURE-----

--=-nIAeVNKkW8S0delCnSTK--

