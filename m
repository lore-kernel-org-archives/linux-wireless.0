Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:36006 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757834Ab3EYTmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 15:42:39 -0400
Date: Sat, 25 May 2013 21:42:23 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Thommy Jakobsson <thommyj@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	piotras@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <20130525214223.4e69a772@milhouse> (sfid-20130525_214242_142591_861A6775)
In-Reply-To: <51A112FC.8060100@hauke-m.de>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
	<CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
	<alpine.DEB.2.02.1305132025560.1278@kelly.ryd.net>
	<20130524164922.GA2175@tuxdriver.com>
	<alpine.DEB.2.02.1305252058060.1282@kelly.ryd.net>
	<51A112FC.8060100@hauke-m.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1H_FodxEvnWCSvpNSbS1SOI"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/1H_FodxEvnWCSvpNSbS1SOI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 25 May 2013 21:37:32 +0200
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> On 05/25/2013 09:02 PM, Thommy Jakobsson wrote:
> >=20
> >=20
> > On Fri, 24 May 2013, John W. Linville wrote:
> >=20
> >> Ping?  Should I drop this one?
> >>
> > Still working great on my device, so from that I think we should go for=
=20
> > it. But it would be great if Rafal (or someone) tested it on some other=
=20
> > hardware as well.=20
> >=20
> > //Thommy
>=20
> This is included in OpenWrt for ~4 weeks now and I haven't read of
> anybody complaining about any new problems introduced by this patch or
> something which looks like the DMA under run.
> I am also for adding this to the kernel.

I'm probably missing something, but isn't this patch already in Linus' tree?
It's in stable review after all.

--=20
Michael

--Sig_/1H_FodxEvnWCSvpNSbS1SOI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoRQiAAoJEPUyvh2QjYsOb7cP/AsdUPSC1r7jLxzo00ag+J5R
LN591yd0cmrLmNR1hZ1BAD6WeGBko7JJ8ZN52tjQQE/jfECxfu7CKWRS/a7jS8Zc
IibnCeeUh9Bbt55a3sm2jMNwW1W8K2BF1L5H7xxHmaOLOt0UAKDg8KnoeeyHFhcq
bvxN/Nsf2vAKe4CQLRo/LHDZ05k7FD6s/0ISaDbdvO3JpWANfJ+XeuyFY2d5tJ72
cJEh9SmPtc+Rs+b3GnEzk1jDQHr3AS48qbkT07M2EaOyMCWSOzsBNHKA4gLqoHS9
RgqAflnT/OU4fGiEo8frDlPXbsi78Tfb2MZjXEi/39Ouvg1CvE3XlBiE91+R5+3Z
51a0y6W4CXZaYQWsl3DMrMSKvBm6cx3aXpD5kT2KH8s6ONdaD0AgwHZBb8pA6k0g
zaxO0FdyQlehDhdUrlMaWmJM84o7+XZsGnw8o6eE5FK/F38APUKAZBgoyi490Eeo
CijujMn13u1Bcuoy5KHN99FdGslbClttMkHe3p7pAYniU1jKVie+Rs3ku9XzODK6
SVmf1zXXFEcVwBjL0dER7lEyT7Z9AI3qWSJ7UwiDEI9rlvUKE0vRQdOVXC+fqe0r
ozBxxuv5Bi4doS779AIyceJNt4gwbuGAgfpAe6Um2veiLc9XUdVK8WRl2W6RcCdU
yTr2sIeR/97n7orJd+fa
=ivUG
-----END PGP SIGNATURE-----

--Sig_/1H_FodxEvnWCSvpNSbS1SOI--
