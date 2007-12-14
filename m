Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbXLNMNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 07:13:48 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20071214052714.GG5698@jm.kir.nu>
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost> <20071210090853.79ea4645@morte>
	 <1197319867.7493.4.camel@localhost>
	 <1197384754.4037.23.camel@johannes.berg>
	 <1197393788.7528.5.camel@localhost>
	 <1197479594.6558.122.camel@johannes.berg>
	 <1197489986.7491.11.camel@localhost>
	 <1197546143.6558.249.camel@johannes.berg> <20071214052714.GG5698@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P0yl2xpSdeOVNgk7lpON"
Date: Fri, 14 Dec 2007 13:09:08 +0100
Message-Id: <1197634148.16079.28.camel@johannes.berg> (sfid-20071214_121350_954660_B57DA64C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P0yl2xpSdeOVNgk7lpON
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Are you sure this handles all cases correctly? There are some very odd
> configurations that can be done with IEEE 802.11 and the rates may not
> be unique (e.g., 5 and 10 MHz channels may share the same frequency with
> 20 MHz channel and some of the rate values are identical between these
> different modes).

I'm not sure why you think that matters. The *supported* bitrates are
mostly orthogonal to the frquency they're used with.

I've just sent out a patch, please do look at it.

johannes

--=-P0yl2xpSdeOVNgk7lpON
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2JyY6Vg1VMiehFYAQKlew/9GW7ZBqNRguNydgvgwVa/Toqhhzvnsfrs
OIl2h+bMxhyV5dO4fYWfTLXQ2fmUPMCrZMWz6DH+jfH1MxzDY2nCgwHHSUYT0Ie1
SG4yi91cz+6XGuFS0V+jizWyGCjJveZ3cm2LUni7S7dpocqs06dZq/2xE4AcB3rx
u6G98Yi4xPIX7o4x7ZEpWM9bNQIVb2KfJVzhNBHivn5M+mTHmTVqUoup+eg8c8FI
1RfQJfX90S+AGoZPZvkGv29u7zVRG3dZ2ebq1uZOtLy/7LQ7Glhdjdo7ZyOu39yW
1ARgYMv0pZ4tzQAXiJxL2LStycagFQz5hTE7CkNWgGqknjAssKf2nx1PDd7wtiZr
pmK7TsPW40OeExIjKwat09+1OHLh4nso0HRSCo6AbC0ce+kuldmWcN0vo49+/v90
My/ylsQ9NmQkk1Li78pqMmPA9Zey+XUHOrEUf1amx4lcJCrKfEPXTiwnIozUKUCW
o36eRoK7FuyHqsYrPJGRKW1IJF4EWXamYWDyyrtVWjlbFZF1MnTortlBsWP0a4gd
KWpD8YqoM5IAKw+7nYaRE6U7pRTT4u0n1Xfa8Nbf4Wwzo8GlTzSJt6eqPCzgGGhy
6f9dlPOFDfg452Sx+8/MTMVl0XeBYiJ9qK9/O+PkEtqFKDHJTdu3LRy9cY96h2pZ
29bVySk0tCE=
=sEZp
-----END PGP SIGNATURE-----

--=-P0yl2xpSdeOVNgk7lpON--

