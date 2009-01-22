Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZAVOyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 09:54:24 -0500
Subject: Re: porting open source mac to linux 2.6.13.0
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Bharat Bhushan <bharat.b.bhushan@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87eiyvl8ex.fsf@litku.valot.fi> (sfid-20090122_153106_546807_B2AA31E6)
References: <d9360e520901212124j7bf196c3sf4e29d8fd3650f9b@mail.gmail.com>
	 <1232621606.30174.16.camel@johannes.local>  <87eiyvl8ex.fsf@litku.valot.fi>
	 (sfid-20090122_153106_546807_B2AA31E6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0NnYVjKohyg7wLUw+AZR"
Date: Thu, 22 Jan 2009 15:54:20 +0100
Message-Id: <1232636060.4224.16.camel@johannes.local> (sfid-20090122_155428_788190_EF570FE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0NnYVjKohyg7wLUw+AZR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 16:31 +0200, Kalle Valo wrote:

> > Then cancel the contract with your embedded vendor and find a decent
> > one.
>=20
> Just out of curiousity, is there an embedded vendor who adds support
> to the mainline kernels and maintains it? To me it looks like more or
> less everyone want to fork their own kernel and then forget it.

Depends what you mean by "maintain", and what you're looking for. I know
many powerpc boards are supported in the kernel, so if you look in that
space I'm sure you'll find something. I don't think you'll find a vendor
that maintains their entire range of boards very long into the future,
but once it's in the kernel it's much less likely to break, and if it
does easier to fix.

johannes

--=-0NnYVjKohyg7wLUw+AZR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeIiZAAoJEKVg1VMiehFY1ScQAL2GFG0j75aUFc0XPDV9/GhP
oMjJFCauXiXfP5eoLx71H2IVWaOBucnnjC2oaKtk0BrGPNK/o9X8ApkM9uz5jpjG
tFa9cdquaOSmhV6mzKmG197rvCXEFctlsSRaqQG20psPU0sc/wKT3yLn93z86utk
PL+7axZFFbYqBS3kg6aCpfXuDtbK1purZzkcYEtXr5FDn96sGumqJb9nFyFcfr83
ZSb672vu63ULKH6Tm73QOdMR1G+9T0l9Oxfw4l6fIF7wzuDyf9caTIGkvcqBFdhh
2TjOdtZk2NELIbIOtLv4MwVIrP5EI6fRmYxyaf1s+K7k254oFs5pA13KJq5AVli/
TRe66/e/9W+B7c2+dlpl6IAjtt+9pRoFBQUrEfw4S4DXdW57jRvly6lya5Ols997
Y1CXdzZwW93cKaDFyjaFXIb0PPyABcdV8y1F2WcxKVxQP51ie2NfZGztnqwmbAib
VaV+GvlbdtSF6mQ4mnlJBwFThdmbOVN56zuIwdPUDRcHc70h6VyBP/t5ys1yct4m
NiW+CMkXLmzR6h59TK9ANLQIcv4fgFoSOms2kn+DkPG0H5P2+nxKpAmpoAAojJdi
rd7kIH/A0e+tcpgv0JwyJQsKBzjoG+bkrVF0Njr1h8zKN1/lfl7k2rT+CelRg+jH
GcuktyGyxGiPDJtjl3vr
=5hFk
-----END PGP SIGNATURE-----

--=-0NnYVjKohyg7wLUw+AZR--

