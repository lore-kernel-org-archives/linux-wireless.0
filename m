Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYLATlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:41:11 -0500
Subject: Re: [RFC v3 4/4] mac80211: move dynamic_ps_timeout to hw.conf
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890812011111h53553a18x2d17c9cf267331dd@mail.gmail.com> (sfid-20081201_201155_333110_CAA04EB2)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-5-git-send-email-kalle.valo@nokia.com>
	 <43e72e890812011111h53553a18x2d17c9cf267331dd@mail.gmail.com>
	 (sfid-20081201_201155_333110_CAA04EB2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o40I3xct8JU9wVAebPNe"
Date: Mon, 01 Dec 2008 20:41:07 +0100
Message-Id: <1228160468.10627.42.camel@johannes.berg> (sfid-20081201_204114_932149_DFBBCB0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o40I3xct8JU9wVAebPNe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 11:11 -0800, Luis R. Rodriguez wrote:

> Would it be too much trouble to add this via cfg80211/nl80211 instead
> or at least add both? The more we can push in that direction the
> better.

That would be good, but I don't think it's really a requirement right
now since wext has the API we need already.

johannes

--=-o40I3xct8JU9wVAebPNe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJND3PAAoJEKVg1VMiehFYrBIP/3LPQalcTiXn7Xyx7sRvEqpF
WFLNicqNR/FwiTDl//xYcsVOJii48n0txtOL08I2RcenMJXVZB2DnpudJ742Je3q
KEJ4rRSPkR5hhPLUDyV62VOL90FygGw8KoBEJNeh6lQs/+nkVUWsUjlK08GtfGmh
rwnbWSUDOS1bWO2AK/b0ZdHsdrVDdpRmfR5to/6tVIfRU/FuVax/k1Z/2X88T97f
35kMcQqylGLEWwDFoy5Q3ru7eqEJrHiU3QxOniq/6Ja2OEGyJbKoZHdHidY1FQkc
5jNfY3N1mG42nUcgmrzMJNskIHXVxYy6dOmLU5iVr++bJrCVwR+9wMLb4FYuvRu2
7fTByw3RpT0Nu8j10SuqnOWD0L5vl9CRUwBtEFVPPTUg/zEONAT+53qEiO6Rwold
en71eYg4pWXj+FZ/2ce4jdVpcInV/6pXhz10tnUF80EltXJnLX0sIe0retLnplkK
Ne9UlSwfNAbEkTaScywUp6FU/D9MjUBEv8v7yu/ufwSLjQczNV8QwhW5teVQa9cT
pJjVL+X1eoDCUAny+h/6lLwCUqaiC1rsgoXU2LroG18qyHGOs3E+JfVTgMPUSPRs
D+spLVNvnh70Et1bNbj+nslh4V9/4SoalPlw4c5fyDms+/3p2lLM+gyhyVrzbSZT
djs1s6nAL4pg72BE9Du7
=JNU0
-----END PGP SIGNATURE-----

--=-o40I3xct8JU9wVAebPNe--

