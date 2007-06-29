Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXF2GHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 02:07:00 -0400
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200706282301.16474.flamingice@sourmilk.net>
References: <200706251628.00838.mb@bu3sch.de>
	 <200706271840.09719.flamingice@sourmilk.net>
	 <1183024620.4769.80.camel@johannes.berg>
	 <200706282301.16474.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nm17Yz4pUdTi5TS6/mhX"
Date: Fri, 29 Jun 2007 08:07:16 +0200
Message-Id: <1183097236.4089.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nm17Yz4pUdTi5TS6/mhX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-28 at 23:01 -0700, Michael Wu wrote:

> mac80211 does this per-frame. It does matter. Short preamble should not b=
e=20
> configured by a global bit. What does the bcm43xx firmware do with this b=
it?

Hah ok. I'd have to look at the corresponding bcm43xx patch but that
does indeed not make too much sense then.

johannes

--=-nm17Yz4pUdTi5TS6/mhX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGhKGU/ETPhpq3jKURAhY/AKCJUTpoxOIrCa8pBmYgF1reCatDkQCfePva
34Ey8+wEuv1QkMQcjL11mOQ=
=4VzN
-----END PGP SIGNATURE-----

--=-nm17Yz4pUdTi5TS6/mhX--

