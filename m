Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbYD3PF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 11:05:57 -0400
Subject: Re: [RFC] WARNING: at net/mac80211/ieee80211_rate.h:159
	rate_lowest_index()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: bruno randolf <bruno@thinktube.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48188A3D.70707@work.ksp.sk>
References: <48174652.6080909@work.ksp.sk>
	 <200804292042.20500.bruno@thinktube.com>  <48188A3D.70707@work.ksp.sk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C+LxRC4TiioJ0jJbKIKj"
Date: Wed, 30 Apr 2008 17:05:45 +0200
Message-Id: <1209567945.18659.35.camel@johannes.berg> (sfid-20080430_170548_637232_C1DDACB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C+LxRC4TiioJ0jJbKIKj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Yes, that would be a reasonable option - providing that we have the rate
> (which we should - there is a WARN_ON(1) in rx-path if it is not set corr=
ectly)

the packet is also dropped in that case so you don't see it.

> As I think about that, I would suggest:
> - no sta info is being collected prior to join/create
> - sta entry is added/updated on each beacon with reported rateset
> - sta entry is added/updated on data frames with just the received-rate

Want to do the patch?

johannes

--=-C+LxRC4TiioJ0jJbKIKj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBiKyKVg1VMiehFYAQKTHQ/+MsjCfIAwrQKibhshU8VAPRwofzi4XMKn
HKkB4gzhUo4jLA92SL8PdXOxOoHW0ERWmt+/p7pLJeT8gnWWaH8k34LUNh4zly/4
LqbNQp3/+laBNirYUbiR7+M+oXCvYCBEr2KLKBpQcFwGYpHLWhSidS/0bRLxEdxN
65tWVITSC2wwXF/I4j2bkdlJNlBEFs5EWhjnKy4WL+jZ8jFKn/HRvIfgqllbs48k
d5l8hPwCZbaeSePjkBPAxuAiDsPBWpMuEBhZYxOquGpm3ydnqYCIGbYMb0a9xUki
8Rr98NSnun9elpT26oxwaZK7ti4JjPkukP/kKAdw52pA/OghCsyuZT354MGZtpZq
1fvwY4JO5ouxdtB1g6RmPo3im54PNmSWM+xlI3A0j1F+wW8tTDEEJS746UwixkLD
qDweG246w0AvUyK1SAiC1KsnqhZ+MYXJzJrTX/qFciSEd5Dp9bZanF9JncNqWTUS
P+U4A6zFVHzi03Fnkm2+nC7/vyXn7WVOoqor6+BbCTdK88oBvCfqnAR9gSRLA7ED
6aFS5OEM4oa/xTk0cslY/BoeuPLivDO4ONj7vTKUvbCJRp+xlog6/7uGKE5LXsdN
D9UuGizCkjrT6KhjnyeLp61tO79onSr8eDWcaHzFZWjgpL5m21pN9hnEl9A/IiUM
VA60Pwo1Cq8=
=e8QF
-----END PGP SIGNATURE-----

--=-C+LxRC4TiioJ0jJbKIKj--

