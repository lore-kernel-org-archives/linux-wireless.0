Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0AURvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 12:51:41 -0500
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: austinxxh-linux@yahoo.com, linux-wireless@vger.kernel.org
In-Reply-To: <4B588FE8.9000705@free.fr>
References: <856792.42713.qm@web55307.mail.re4.yahoo.com>
	 <4B578BAB.9010608@free.fr> <1264065257.11396.32.camel@johannes.local>
	 <4B588FE8.9000705@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9chSiCXSXNTyjZw47hkY"
Date: Thu, 21 Jan 2010 18:51:33 +0100
Message-ID: <1264096293.11396.61.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9chSiCXSXNTyjZw47hkY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-21 at 18:33 +0100, Benoit PAPILLAULT wrote:

> There are things :
> - HT Capabilities IE : this should be the hardware capabilities of the=20
> sender, be it a member of a HT IBSS or not.

I wouldn't advertise that though when the IBSS we want is not HT. Less
confusion that way.

> - HT Information IE : this should be the BSS information, shared by all=20
> members of the HT IBSS I think.

So we even need to adopt it, maybe?

> BTW, currently, there is no way with iw for the user to tell mac82011 to=20
> join/create a non-HT, HT20, HT40+ or HT40- IBSS. Maybe we should update=20
> iw first as a requirement for HT IBSS?

Indeed, we need nl80211/cfg80211 changes.

johannes

--=-9chSiCXSXNTyjZw47hkY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWJQiAAoJEODzc/N7+QmaBnkP/3/K8cnnD3iaOmoxj6HVgc/R
WS7btP49QAzk+7vm2rjaE15cqy6QHqWm8Y5kczEynRFyNBphnK+Egs4lfZy34H8q
g6l24e6teQAasiyJAlacs0LhUCNJq4XONleIJZavTV7/7pomiHxbX/RD6KMMIi/z
W6Gujj6Ecz+gisQ9dS7MQY+2YEx1FWMaawUFoX1A/isYPtN7ELJd9gpCMAsDnP5E
KtMC87WjBYDtKNC9jT4l+vsgtrHvNglLHAi+F+ZVpsG9qDpg0MzGph2tjj8Bj/7X
4FbApInGWxnVA4kS77Ss9mAiUa++OIbf0BpTs+TWV+fxu3bBtTmqNB3NLOXlgqrc
6mYVNN49c1IcuRnkKjl4FLd3NbwNUCD0wNSPRnUKMEX/cpg+aTdvCu8Q9nRRUlkc
gKPASsSGHbGnAWa5KaIouGMry1TS3vc9WWaEIckemNjRpwRy9WrnVgXWBMBoGf+e
N1cLwCliRe3V51Rt5tRHhphh8oMuvha22pjfPtCjDUWqIlYGlnjoQfVfahMNvf6g
dfvzHOiKpNmAvBJY64WV5BAAeCXAo/LhlpBlViimMk+mUSDw0CJEpgs2Cv/qFUJM
9h60vt/AJ5X+YseqgQvE8dfigGDyTXoLvherDCKyJuOvwY37nUPFfJSU/voOeQSF
ZGKjawp0zXeSuKvt6Bh9
=H7uY
-----END PGP SIGNATURE-----

--=-9chSiCXSXNTyjZw47hkY--

