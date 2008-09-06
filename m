Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYIFRXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 13:23:10 -0400
Subject: Re: [PATCH] Ath9k: Add RF kill support.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <1220721572.10102.0.camel@johannes.berg> (sfid-20080906_192003_595621_9791F144)
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
	 <1220721347.6714.114.camel@californication>
	 (sfid-20080906_191538_728310_1EC0FE5D)  <1220721572.10102.0.camel@johannes.berg>
	 (sfid-20080906_192003_595621_9791F144)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ivoudtRfgz6WIl2qFLg3"
Date: Sat, 06 Sep 2008 19:23:08 +0200
Message-Id: <1220721788.10102.3.camel@johannes.berg> (sfid-20080906_192314_597964_10EBA16C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ivoudtRfgz6WIl2qFLg3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-06 at 19:19 +0200, Johannes Berg wrote:
> On Sat, 2008-09-06 at 19:15 +0200, Marcel Holtmann wrote:
> > Hi Vasanthakumar,
> >=20
> > > CONFIG_ATH9K_RFKILL needs to be set
> > > to enable this support.
> >=20
> > why do we have to introduce yet another config option for this? What is
> > the advantage of disabling RFKILL support? I really don't see it and al=
l
> > these extra config options are rather confusing than useful.
>=20
> "if EMBEDDED", I think you may want to build a router without rfkill
> stuff.

Although I don't like all the select business, can't we just have this
be an invisible option and make it depend on RFKILL? That way, when
RFKILL isn't selected, ath9k-rfkill won't be compiled, but if it is, it
will be, and RFKILL can be "default y" and "if EMBEDDED"

johannes

--=-ivoudtRfgz6WIl2qFLg3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwrx4AAoJEKVg1VMiehFYqvYP/RPjRqQvfT9NP/aNiefdDobQ
5+ybjKFCGsGxV2PhK08NbLJam3Yj4D3JdJDkpubldeAJGEO/mjis1TakWYdOb7PB
h35UcI/fnfPv+FxxZHIkW4GK45ZrFmeDTDh1Q87iC7zF+L+Oe0vFJvwJZyY4nWzl
JiOw0Gi9YuAhlzhs8jjpfXnxoQjxNo6Y+cTT74ZAdjFvH5/PvRMcoNIqRqB++f1o
/MBusQXmH6aNeOHlusOErnPWoAjEmnJ2qhZ66+KZ9uMbsUWClMQGMAczURfQjwiD
8wgnGUxfyZ3dD95l3AFWpOa995w8nUXTOCEsMrwbPhTdry07+vC1IEl2AszUEXUZ
bro6OtgGqnUvtSAy61SmZ+ix5pLBHTz0UVDtM6U2Bf4/uBv73t+jTLL2po+HaJHq
o+W/DkDf3SDkCwx+PDIJ9cgWnOrvR8Y3bbTuH5VGxUkkPOeO1xpMefSBM/pFDcgv
SXau0aBOgMk+BXLPNyspR2iUuhpkDilDV5zSQUZ2mR4q/QHUmjWWtkKwSH8D6vnp
zTSnrAvViJodjXAczmf/xpje7t8yEZvuZyoXX+hp9nKuX6bZp8bGd7ydfIusmtuD
oV075EOLTNLPpvNzOeHKDFGcWRk71KDi25FHJDwFabrzdDE+6tk4b0x9bv7Z6r88
2JbT4aL/abKBENfYzbm7
=u+6L
-----END PGP SIGNATURE-----

--=-ivoudtRfgz6WIl2qFLg3--

