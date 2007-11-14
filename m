Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbXKNQDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 11:03:08 -0500
Subject: Re: [PATCH 02/15] mac80211: adding 802.11n definitions in
	ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11950542003481-git-send-email-ron.rindjunsky@intel.com>
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <11950542003481-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GhXqrNcPI9/G5BJWBwVc"
Date: Wed, 14 Nov 2007 17:04:28 +0100
Message-Id: <1195056268.4091.24.camel@johannes.berg> (sfid-20071114_160312_145910_349D7C73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GhXqrNcPI9/G5BJWBwVc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This patch adds several structs and definitions to ieee80211.h
> to support 802.11n draft specifications.
> As 802.11n depends on and extends the 802.11e standard in several issues,
> there are also several definitions that belong to 802.11e.

Do I remember wrongly or didn't you want to add comments here to explain
the structure names?

Thanks,
Johannes

--=-GhXqrNcPI9/G5BJWBwVc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzsci6Vg1VMiehFYAQJFdhAAiD9js1eoMKg2AZBQi+LixtPmdIRj7CIS
FviNbujMh8ZdzB9u3PMaY/fxsTqDJI+JpYLFNorS9FYmc+jYMU9RXKODPxtPTJsN
WqwX/bwo78Z6RO2hR39DR89RfKbbD272Qqfa4hqbF73Vo8qoL5RniDQ6JLVsOCnc
W36NzxJco9w2vFPFDGmoIRQFyyyoRZ7rzdnLa3htcqvtUJ+lgklna/4KHX0voN0L
BBBGIaspMlpE1H6Yw6Si6LPJaI8scSMi8brC7f8NupWG4XzII+fUbCPkK5zod/xu
4jUsp7ylzV9UJuOZncCzUJDbnxN4RyhGXgSycKER4GARQYEyRY0jSqRFUKFi5N0z
nwOyxGijqZfYSI/LexSYcG6azOL6y8UsHcQlBAg4wxAO26Zte5kRM4CmNWOZsO1l
XLrk8C6HXWwu61OJ9ZygVgT6vXbGgYIWfmZXqevD2xnaSYe43fJbLi21L95aihjI
DYTnYyAOgU9MBP/nazFBdDeDdzDQ6HXBJYrVhbXF5q/oLkl74iRm8emHnB6ASbfT
1LN3AtzthQ49lX8qu8jZkY3vpKNGyeGEWlP+2ciroupBIlENXNfCDvZkC9a6QAED
g8Ed8hAUL9tBUADQCNjJq/O+EIjgkou7p1Wjuq5KaHrShFq68dwdkFLREZ8Si/Uh
VaWhr8e/zXM=
=aK0T
-----END PGP SIGNATURE-----

--=-GhXqrNcPI9/G5BJWBwVc--

