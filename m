Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbXBENqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 08:46:31 -0500
Subject: Re: [PATCH] d80211: Add API to generate RTS and CTS-to-self frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702051412.50703.mb@bu3sch.de>
References: <200702051412.50703.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oOOTnbZHUZxvGCRIRELJ"
Date: Mon, 05 Feb 2007 14:43:00 +0100
Message-Id: <1170682980.3572.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oOOTnbZHUZxvGCRIRELJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-05 at 14:12 +0100, Michael Buesch wrote:

> -	u16 rts_cts_duration;	/* duration field for RTS/CTS frame */

I'd think this was here for a purpose. Maybe some hardware generates the
frame but not the duration field?

Then again, if that's the case we can always export the functions to
calculate it as library functions.

Looks good.

johannes

--=-oOOTnbZHUZxvGCRIRELJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFxzRk/ETPhpq3jKURAsQnAJ4+1sr8kccuSSrusBK3jfj0GvjuKQCeOaeg
MfMqRkOuTkP0fX/EwxdjeWI=
=x0q7
-----END PGP SIGNATURE-----

--=-oOOTnbZHUZxvGCRIRELJ--

