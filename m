Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZGaH6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 03:58:42 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249026181.29587.14.camel@johannes.local>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
	 <1249026181.29587.14.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MDRdiwxXcPYoZOBd7wSH"
Date: Fri, 31 Jul 2009 09:58:07 +0200
Message-Id: <1249027087.29587.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MDRdiwxXcPYoZOBd7wSH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 09:43 +0200, Johannes Berg wrote:

> Fix it then. Offer an implementation of your superior solution.

I just don't think that this patch is a solution because it means that
we'll be connected to the AP forever, without knowing anything is wrong,
if the AP can reach us but we can't reach the AP (maybe because we have
a good Intel card with great sensitivity).

Sure -- it's possible to factor in transmit status reports (but remember
that not all hardware gives those reliably) or do things on a different
schedule etc. But as long as nobody wants to really improve things I
don't see why we should take the regression and _remove_ the current
behaviour.

johannes

--=-MDRdiwxXcPYoZOBd7wSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcqQKAAoJEODzc/N7+QmamJgP/1zj9+gpWM4WWU+eANXhGyDT
XG7xUdNdMz1ADamyGPA/eyFP/2WEuY2/02W492nS5O0/OyocgrNlwVP5ShQHy1Wb
JXI4KSfsSGrGYbcnLcXl6F1WHFPrXECfi5hk0y4UrdtZ2SifW/IvxTwCNsHMSE+e
oBHSkjUXiBtjKCk32C3iGJ/UUd0dI40XSAgUkIUyouWBUqflLI/9T6Rh3+6hAHZK
IAyxirT4ccqcu+UmrgbcbAuz5AmjcVlP2Wc6qRgZHNljSzJ9hOZKl728Q7+tEbQc
7q7HoPrDW34UZ089CSP9s8p1rYGqXeidFj4wjun0PnIsQniyyZNjfNRK4AchzjY0
NKuUWwKZz1ViC+mk1C2gYxwXr/mdIwiZjzlCjVVE1Utx1MF+m894pC+50IiRC1j0
q8WDONBI28Qb7zFgVeFgKhh88R/sxg245CZOE2wiNn1bg9pRFO1u66iGekGKu+Me
wsDUOWxwWNOk8bZE740eyYWdBNqayqbC+s3SzGo+6APnNIoHorVFRIRZ9A7fPqk+
wNZZ7t+2lKoZ20+c1wpyWCgSi9wMOONhDLKUCSxA3auvn40EMjsnVnozziNeTPET
XHB0/d5+tGo9NAA4qqvDc6z+9grnVKe2sjwIK6XFvBSMNUiWh8dk8lAgaWr9CSgz
frM7yh73CQD38kEQw8UV
=NQoC
-----END PGP SIGNATURE-----

--=-MDRdiwxXcPYoZOBd7wSH--

