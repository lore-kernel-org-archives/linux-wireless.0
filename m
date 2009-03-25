Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832AbZCYRlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 13:41:18 -0400
Subject: Re: [renamed] Debian crda?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kel Modderman <kel@otaku42.de>
Cc: debian-devel@lists.debian.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <200903260337.37783.kel@otaku42.de> (sfid-20090325_183755_097258_8D534C5D)
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	 <43e72e890903250047o6a4ed5cfm4ebb849013e9d571@mail.gmail.com>
	 <43e72e890903250051j44955276j42fce045c5079b87@mail.gmail.com>
	 <200903260337.37783.kel@otaku42.de> (sfid-20090325_183755_097258_8D534C5D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VdU59DXui1eUCziUIj3B"
Date: Wed, 25 Mar 2009 18:40:29 +0100
Message-Id: <1238002829.4320.162.camel@johannes.local> (sfid-20090325_184122_478062_CB127BF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VdU59DXui1eUCziUIj3B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 03:37 +1000, Kel Modderman wrote:

> > And as its probably best to coordinate with Ubuntu, they have a
> > wireless-crda package which combines both into one package. Its
> > shipping for Jaunty.
>=20
> And that's the only way to sanely package it (by combining the two pieces
> upstream splits) as show by Fedora also choosing that route.
>=20
> Luis why can't CRDA and regd simply be released in same tarball consideri=
ng
> they have such a strong relationship with eachother due to the openssl st=
uff?

I thought regdb was supposed to be a candidate for volatile.

johannes

--=-VdU59DXui1eUCziUIj3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJymyIAAoJEKVg1VMiehFY+2EQALks00HFrtZ0JnnRN8E982i9
t0qG78OpG7lyhtmOCEG2BU0laE2OvQeigxSX2tXueix8WCuiv+KqEg2fb8DqX9gh
rrBSUr2WGrDI+1oqRSPmW8mj4DCy7MapMPbF/ZHtsf7JHK4ljN4tyuluJyn+YOs4
evk9pDsVnKBFjFmc2MolQ93jz15e/STnWYeF3ZQ6XjZ2qzn72QCgd05fj0TgUUhd
5959OWNOjUhumD+bqXG4yGI08fZvpyPtlWr05sbfbPxXqcpTH9WKADJepT/q+5FG
4p9MOtkZd0D1nC3dHa9k4xzVF55XgtdtR0V4UFCLqeM86VMUfoMel4opaAb4KD5K
8Zj/rc1hb3LC3EsCZVJMVvYhBI/h3YuAu7GR1bkRhG6jkUG7Gfp54VgpbA6ahJD1
1ihR477Co94yZ/60TnnW6Wu/6wYf2J0BUwEnyoqcKuTU5La5wonaCVIhCyb2+zxz
RTUKIyTsRtXup+tvOVOuOrW5OOgcWHG3F6np5/YyUcXjTepM7vWhpfkah1i5+/ym
6ZMZKhIjShGM5dU+BFykfzOB5bsoLUsq/7mPZNeZHl+16Nb/5Dklfca7zVvKEDJF
74kqRG4+Sx3aXz42O0efgy/kteDFDD2L+QHITQ2MoIW4CkZLmOyBg4eh+tbhT2ap
91dwOovKVa4LpzPrBIxY
=aIP6
-----END PGP SIGNATURE-----

--=-VdU59DXui1eUCziUIj3B--

