Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXKTNtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 08:49:39 -0500
Subject: Re: [PATCH v3] remove bcm43xx
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <200711192357.44407.rjw@sisk.pl> (sfid-20071119_224049_686469_3D7B65CA)
References: <20071119202121.6ad3fa70@morte> <200711192300.12183.rjw@sisk.pl>
	 <20071119231935.535674ba@morte>  <200711192357.44407.rjw@sisk.pl>
	 (sfid-20071119_224049_686469_3D7B65CA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ly/pmAzNlvwOcS3regz4"
Date: Tue, 20 Nov 2007 14:18:42 +0100
Message-Id: <1195564722.10920.17.camel@johannes.berg> (sfid-20071120_134941_277582_FF7DAEC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ly/pmAzNlvwOcS3regz4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Many people use the old driver and you are forcing them to switch in a ra=
ther
> unfriendly fashion.

> IMvHO, the schedule of the removal of this driver should be discussed on =
LKML.

We can post a patch to orphan it and then ignore it. We actually prefer
to remove it so people use b43 and we can fix any issues they had.

Face it, nobody is willing to maintain this old thing any more.

johannes

--=-ly/pmAzNlvwOcS3regz4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0LesaVg1VMiehFYAQKIMhAAmDRtFKKp9+bLY7GVYalhvHHiGGKhifvB
7EE0+BK04MUyCOysyolPJPXwTDHx9A5YRz2G1nuEnG56FpPqF5oThHqhewuQNEed
BSCKtnaj+IHo1fCsUmbYX+9bviIWyVtg8pm7CUjoVs33cDw9L68CQhzVmkruGtaA
zaycZnECSlEEIogIQOG4KYnL4Gh6KJ7FdGaEQFXSVUkv2w1x1oPkhBHJCh+gzkce
AGjiODmIyygOuv0BZHxtmscQ8eVxdzJOI0jXTC2gTfjiZLIxrBzfFE0SHa28UUeb
rAQv8FBk9iTGtmZOQr+DjMqeBMPGpyFkL0YJ5S0mlV1raTv/9wiI7PWY/K0WB794
QCFllSg7zioDpg25eGR/0UF/B4JQlKOtHlsrNyxe5wT5FWoYYD+isAq6+BTedS+T
xvbOsxCDGZHXEPxn6swnB+dJlQT8mlHOibMPS/Fhnytri8hg3M5U9SnwqtoHt8XU
Y5ang54w8q3RLSLCne58bQD3XJuQs+2DXg2LhERIOmfYCn+CYa91ALy2381IMQAM
vsO4zsM5atD5jIq5hXFKNpDj0mOGqxC/r4t/7gO2/nIbm7DvM3HVcA9uhAGyDjwU
SGLs776tRSrD52nM+/zsRSe1aiJdb7m1fS6rsh5sjNarbP8TjoorgThEKoy87/5B
Hc9e99JKOfI=
=vCo3
-----END PGP SIGNATURE-----

--=-ly/pmAzNlvwOcS3regz4--

