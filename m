Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49058 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaERLxn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2014 07:53:43 -0400
Date: Sun, 18 May 2014 13:53:24 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: make B43_PCMCIA and B43_SDIO depend on B43_SSB
Message-ID: <20140518135324.415cf8d4@wiggum> (sfid-20140518_135421_048005_5D85EB50)
In-Reply-To: <1400413293-25973-1-git-send-email-zajec5@gmail.com>
References: <1400413293-25973-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/T+QJe2k/V31EJ/dhuJq42vl"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/T+QJe2k/V31EJ/dhuJq42vl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 18 May 2014 13:41:33 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

>  config B43_PCMCIA
>  	bool "Broadcom 43xx PCMCIA device support"
> -	depends on B43 && SSB_PCMCIAHOST_POSSIBLE
> +	depends on B43 && B43_SSB && SSB_PCMCIAHOST_POSSIBLE
>  	select SSB_PCMCIAHOST
>  	---help---
>  	  Broadcom 43xx PCMCIA device support.
> @@ -93,7 +93,7 @@ config B43_PCMCIA
> =20
>  config B43_SDIO
>  	bool "Broadcom 43xx SDIO device support"
> -	depends on B43 && SSB_SDIOHOST_POSSIBLE
> +	depends on B43 && B43_SSB && SSB_SDIOHOST_POSSIBLE
>  	select SSB_SDIOHOST
>  	---help---
>  	  Broadcom 43xx device support for Soft-MAC SDIO devices.

This makes sense.
Ack by me.


--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/T+QJe2k/V31EJ/dhuJq42vl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTeJ80AAoJEPUyvh2QjYsOdJQP/RM5qc11tqkBhULtlk+46KuP
ZbX1xJzZNMz7LJqVi58lNPvkZrqSKvB+yU+uoldetkLpByr4Utu7EWp9+Xhkgwoe
heA0jKHZPSXIAZJhlYCECl0df/xAAC1EJqA71dG/HvYCjuryZPvLjS2o/fKkNgnu
oceOwwrJXA3PBgZYMlVhVx0GmnqMy+i5e0UllcjW44gVn70AwD2TG0hrh6xMbY8u
NxBYhH2ggUOUbXYnlE55mACcGZJfHV1gogvHj37wkX1TS+o76xKdyhzxNboWDkeA
iKRUR32K1fWPqrH0+JVgjo6OmNxF9BnqDCcuMpieCHtK7gLN9UgfZ8/0cpgCI87N
jGDQ9zgnuMZhjO7b4UmYtqFPBjqg0qBH6KWc739ZVV15445yJv1A+nIBzL55OyVQ
FCzKHjPG0fX8Ym4HSkCVy7tCsVqusN3KS2cE59wKkK9NBY8YNgRIFMxGYBP2ytQY
EQ5J+TEMfjEpOLg89Iw8qrKYV6BJEtQOWpkLDrYMdmJSD41JFaPMKwjBDpuvVzOU
Rod1R+xFiD96x1SUl6dGrYzHlfAi0bU0BSzfw7bbHTTfhR3AiwVg/77EOm7pzBqi
zA7dGpOS3JvD+/N1BlBIH2tf4o4MstOy5p5LGYQk1eNnq8fav9xmg7Js/Q1R2CdM
oCVaLm10Fhejf1w3mI6r
=ca2G
-----END PGP SIGNATURE-----

--Sig_/T+QJe2k/V31EJ/dhuJq42vl--
