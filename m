Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbZEDP6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 11:58:15 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241452364.2903.3.camel@localhost.localdomain>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423924.8683.9.camel@johannes.local>
	 <1241427107.2899.9.camel@localhost.localdomain>
	 <1241435567.8683.35.camel@johannes.local>
	 <1241437035.8683.37.camel@johannes.local>
	 <1241452364.2903.3.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rbsycBuHn/77tpxVkUoS"
Date: Mon, 04 May 2009 17:57:44 +0200
Message-Id: <1241452664.8683.51.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rbsycBuHn/77tpxVkUoS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > I've done that now, and pushed it out, but I think the RSN IE printing
> > you added (and I renamed to print_rsn_ie) is missing some input length
> > validation, could you take a look at that please? In particular it take=
s
> > the count from the IE, but doesn't verify it fits, I think?
>=20
> I can have a look at it since it is by no means perfect, but at least we
> know have something that allows us to not bother with iwlist.

Certainly. I just don't want to have it crash on an AP that advertises
completely bogus information :)

> Btw. I named it WPA2 on purpose since not everybody using iw will
> understand that it is actually named RSN. In the end it is your call,
> just to let you know why I did it. One of my first patches actually did
> use RSN in it :)

:)
I was going to call it RSN/WPA2 but that was too long for nice
displaying. Now that I think about it though, I think RSN is more
correct because WPA2 certification doesn't include any 11w things which
this will include. I suspect something like WPA3 will be done for that.
Who knows :)

johannes

--=-rbsycBuHn/77tpxVkUoS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/xB1AAoJEKVg1VMiehFYoNEP/2Z+3IyzMeJWBE6Z6lFChjeL
icEvJKXYmrvH4nVgfW98dFQhwNLXnywR/wNyjzBPLyKVdaGspTuNFVsT8imqKnw9
fzwbWZQyboTVVLCFuIRRqu5ovRg184nqYN0YR5GfYsir1cNgUsv/hDSGeBi4rW4M
HA00EiK4sZuKp1D+Yg5UJ0DHm6/PLR2NEp7gJR9YFuMEwUYAs3eTCg5ZrGiF7kW3
Qlhy3CDIgAeAmAm1r6utNfkniP8k1iGqvZjxjUTGzK7j7HRw7+t7Rfew0ZPaJNuY
SgvN3tpwIEib3/JlxoajrnDddGuwvFZcft0pcYwEitbJwUoAMphTWzj30p+XAAHi
NGGeSqhKCUTSdvsM/eW5QD+cv6D12mcJ2/COwEdq4Be1tmv/37+ZVSc5CvPZLJgx
yvWLiMeEHB3oTlW+t/fqN2xAAqU/0EgL7D8CJ0xhsj5Wa6jyHSa0k0lAm9CVF1PA
6YYzWAPA6yatgrMIwKYNfU3DL/9M7G+BPG4ECl+iNGKmOJJnQm95ii2RUeGiY9tL
5hQJddfDNswyChet9gDOXsMJn9PQTVkPVXBaW+SBzRSAF2neAdX7fCUdqZg3Djsl
KeUBshyS/M+nsS2Jxhwswro5mFzCnK0wg1eipUwh1yqmFAifGL4F+DeOn7xPFXFC
9B08885XeDWhQalDIC4P
=8xVC
-----END PGP SIGNATURE-----

--=-rbsycBuHn/77tpxVkUoS--

