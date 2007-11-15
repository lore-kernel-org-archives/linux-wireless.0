Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbXKOQus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 11:50:48 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <877ikjsvfi.fsf@nokia.com>
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605550.4793.93.camel@johannes.berg> <20071111025808.GK4031@jm.kir.nu>
	 <87pryfd8cc.fsf@nokia.com> <1194953217.9116.38.camel@johannes.berg>
	 <877ikjsvfi.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KtG7QcHxRe/uG7olOYeT"
Date: Thu, 15 Nov 2007 17:40:24 +0100
Message-Id: <1195144824.13846.65.camel@johannes.berg> (sfid-20071115_165104_729115_EA041CF4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KtG7QcHxRe/uG7olOYeT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > The N800 and similar devices only wake up at DTIM beacons, right?
>=20
> At least N800 and N810 do, we don't want to miss any of broadcast and
> multicast traffic. But I don't know how other mobile devices wakeup
> for beacons.

Well, if they wake up for all beacons they're using too much power
anyway so I'm not concerned.

> At least from my point of view that could possible. Of course it feels
> like a bit of a hack, but I guess there's no clean way to implement
> this.

Well the scheme with distributing the beacons would make it seem a lot
more like it was implemented in different MACs, but that's quite a bit
harder to implement.

johannes

--=-KtG7QcHxRe/uG7olOYeT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzx2d6Vg1VMiehFYAQIGyQ/8Cq2iMz4vx02GL4iegAjuALSWbHxB9QXp
f9VP/Pipz4p54F4H9VMmbFS96ZpU/DjYoOxsewEXTEd6tEBs2AQYa/iBFcj3Eehf
R+YIyL2Soy88OVPbpbIq+iwlmzOVb7Yrw8zOZZ1RC8LADnfuwMJTBHaCZQL/VRE4
cZuMPISQaFAzYNeFwrs91Spaw9/li9n4F0MRy6S2Gp5lNzcZaIVTZLdeIKdZJAt+
Lr1koWoO2fuPVY9NqOfxcH2/9LPBSz40kQZ5MmF7ESr3WVssI54cKBt3sYjFH9rV
V8srdbcbvVeWLexhIm2b137VjqYtYoygISf4OAJbFWTPw4ctxzvkQ2dDbGpMZTML
9BttPEgRnPtjMlT06vA2WPeAhodprD88BaTsWpRmuFFnqyx1EY5nBkHOrFk8PkoB
vjU8g1i5ZTEe9xQ2dYcpBy7J5W2KUR0bYnLl4s+sdiw92Sbq/HYed3mt0TtTs7ZH
1yvBsqaziYglQaS0R0kQ6RwuhGdCy/tbU3gkskOswNhEeVi5j9hmwsk4TuQ357g9
jPn9q+5j9S7HBNPJEY0vIWR6cPOfuIS2hcFHvhdqvgFuoQdwJ8Ry0UrlEKhdeHz0
n+dvBoWprFmj/7/PY+ZkliDmOoeSPMvqAGv+h2/HYISI+9fgIncN3X/wp1Z1beth
W1htzdHkSFs=
=fJaM
-----END PGP SIGNATURE-----

--=-KtG7QcHxRe/uG7olOYeT--

