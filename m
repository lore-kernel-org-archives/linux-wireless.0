Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313AbXBGN66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 08:58:58 -0500
Subject: Re: [PATCH] bcm43xx: Fix for oops on resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <45C9D930.5010307@lwfinger.net>
References: <45c8bd59.oamnvaNRMZvKoPBa%Larry.Finger@lwfinger.net>
	 <1170850549.6798.22.camel@johannes.berg>  <45C9D2E1.7040906@lwfinger.net>
	 <1170855150.6798.38.camel@johannes.berg>  <45C9D930.5010307@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9jRpBJcTCvtAsdp1bUZa"
Date: Wed, 07 Feb 2007 14:54:50 +0100
Message-Id: <1170856490.6798.40.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9jRpBJcTCvtAsdp1bUZa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-07 at 07:50 -0600, Larry Finger wrote:

> Could you please apply this patch and tell me what gets printed after you=
 resume, and whether you
> did a suspend to RAM or disk?

Not a bad idea. I can test suspend to ram as well as to disk, just got
both working again.

The kernel I'm running right now was built on my powermac so I can't do
it right away (otherwise I could've just recompiled the bcm43xx module)
but I'll do it later today or tomorrow.

Usually, to get my connection back after a suspend, I just have to set
the ssid again.

johannes

--=-9jRpBJcTCvtAsdp1bUZa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFydoq/ETPhpq3jKURAgBZAJ49QdaU3ysezdokLHtd7ZVAjQTVXQCggfRn
0mv6T4AgFAjAqjVV5BkIC6o=
=D62B
-----END PGP SIGNATURE-----

--=-9jRpBJcTCvtAsdp1bUZa--

