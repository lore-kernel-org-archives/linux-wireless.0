Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbYABP2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 10:28:06 -0500
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <200801021623.36089.mb@bu3sch.de>
References: <1198253375.16241.76.camel@johannes.berg>
	 <20080102084532.GA17960@infradead.org>
	 <1199263934.4172.69.camel@johannes.berg>  <200801021623.36089.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vlFTbLowXYtGFFvQHwfC"
Date: Wed, 02 Jan 2008 16:27:32 +0100
Message-Id: <1199287652.4172.90.camel@johannes.berg> (sfid-20080102_152810_882936_9EB5AE42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vlFTbLowXYtGFFvQHwfC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> What about simply _not_ failing the initialization of mac80211, if no
> rc algo is available? I mean, we can just use a fixed rate we get through
> WEXT and stuff. Simply start at 1M on init in that case and stay at a fix=
ed
> 1M until the user sets a different fixed rate through WEXT.

Not sure. I think I'd prefer not to have all special cases all over, I'd
much prefer a new rc80211_none or so then.

johannes

--=-vlFTbLowXYtGFFvQHwfC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3utY6Vg1VMiehFYAQJjbQ/9EDI4RpZbXIExTd4lfYsiLTVg6SkyJJbE
8mOrC6L8Zhh83dORY5ayZ6Dh/9AI5sI6vJCPLsK0zguyre9SGV1Pari+6GBqoDts
b7U0/9TqZ5GEfe5TVWufw2iYwpDXmpcmlD2JkCq54KprF1lFkcMVRwbsf1x5xHCV
51S0+ioLU2qETENVbwcrbmAcc+Uk7lNmona8SBbIwAqr04lMcAFflix9rLMyjVIp
dZS2AMBMRNSJoszkwrN0YBLPP8yrhwhhHhKdaOPqskCf9s4CoZTBY8GYzM3H+7sP
QXn3Svtj6G2bmwyJpHkc8VgkKc5I6xr2xoFh+Dz2hyAOF0NhFoK+0BaE7ETEsTGQ
4M5kRc1EVQMX5aLrTziVNWCRNeth9Ci7M6kiuG8460wC+NlO2TfQtZ1m4KBZKTtT
8rmhYrZEl6yfDt35lU/+Spnq42luJFcja9pf1fmS6WQjBmujQ12KZXgfBwIJWbl8
1LObZlczmX91TRTydoz67DE3KxhLo+Ph7g55FJkMKynR79h+HUqT7Jl6XMs9zutd
JeJNRHnCcvJYqa3ATHaxFLmF54Vi4lJnFXjz1wHf8jMEDZr9gz7A1Ag6vw37MoBf
ahbuGf9oHzTxO6J3AmG8BnzIpv8LNz30qyl11EmQHgiypQ05aeyjw9Kb1OULewcP
ni76Evy2lvc=
=aF21
-----END PGP SIGNATURE-----

--=-vlFTbLowXYtGFFvQHwfC--

