Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763123AbXHCWM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 18:12:59 -0400
Received: from [84.135.224.6] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IH5OB-0006tt-NC
	for linux-wireless@vger.kernel.org; Fri, 03 Aug 2007 23:12:56 +0100
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1186178959.13315.30.camel@johannes.berg>
References: <1186178959.13315.30.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rd7T+hpxzc8BcSTdW4zL"
Date: Sat, 04 Aug 2007 00:14:00 +0200
Message-Id: <1186179240.20275.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rd7T+hpxzc8BcSTdW4zL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-04 at 00:09 +0200, Johannes Berg wrote:

> depending on the interface flags set FIF_PROMISC_IN_BSS, FIF_MCAST,
> FIF_BCAST.

That should be FIF_ALLMULTI and FIF_BROADCAST.

johannes

--=-rd7T+hpxzc8BcSTdW4zL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs6io/ETPhpq3jKURAuTyAJ0SPlvUOL8Q+XjSK3KwqwvNWTH0ygCeJr7s
/mJNr1Vtkgspk+Ob37qnY6Y=
=v0vW
-----END PGP SIGNATURE-----

--=-rd7T+hpxzc8BcSTdW4zL--

