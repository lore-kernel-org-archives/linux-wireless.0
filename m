Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764064AbXHYIBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 04:01:41 -0400
Subject: Re: letting drivers choose their preferred rate scale
From: Johannes Berg <johannes@sipsolutions.net>
To: ian <ischram@telenet.be>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46CF95F9.6090802@telenet.be>
References: <46CF95F9.6090802@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gUDcx3B+AR+L6Cp1+2Ng"
Date: Sat, 25 Aug 2007 10:02:42 +0200
Message-Id: <1188028962.9529.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gUDcx3B+AR+L6Cp1+2Ng
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ian,

> To be blunt: looking at the possible routes of action that i see:
> - re-review the patch to allow the drivers to choose (preferred) rate sca=
ling, and give it
> a chance to make it in a future kernel.
> - propose a feasible other course of action
> - Simply refuse this for good reasons, leaving this issue to exist for lo=
nger,
> and giving me (one of the kids with too much time) more explaining in the=
 irc channel.
> for 5 lousy lines of code.

> ps: for reference, I'm talking about the "Specifing rate control algorith=
m?" thread which started
> the 10th of may on this list.

There were a few specific remarks about the patch, e.g. that the default
shouldn't change as soon as a driver loads another rate control
algorithm etc. Once those are addressed I see no problems with merging
such a patch.

johannes

--=-gUDcx3B+AR+L6Cp1+2Ng
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGz+Ii/ETPhpq3jKURAkqTAJ9rrFPwadTQQxOJTllGVH9keD1GKwCeONsg
WgrbWR6ZvHtm0ZIXRc8gqQs=
=tAne
-----END PGP SIGNATURE-----

--=-gUDcx3B+AR+L6Cp1+2Ng--

