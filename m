Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYBMMLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:11:38 -0500
Subject: Re: [PATCH v2] mac80211: give burst time in txop rather than
	0.1msec units
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Christian Lamparter <chunkeey@web.de>,
	John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200802122142.10325.mb@bu3sch.de>
References: <1202658578.11481.4.camel@johannes.berg>
	 <200802122021.21211.mb@bu3sch.de>
	 <1ba2fa240802121157t370c8418v8a24484596ce5bcd@mail.gmail.com>
	 <200802122142.10325.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QGujRpmSjfgSNn3AFMeI"
Date: Wed, 13 Feb 2008 13:10:25 +0100
Message-Id: <1202904625.8931.37.camel@johannes.berg> (sfid-20080213_121145_475167_2ABA80F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QGujRpmSjfgSNn3AFMeI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > > > > +  * FIXME: The default values in the spec (IEEE 802.11
> > > > > > +  *        7.3.2.19 Table 37) are 47, 94, 0, 0, why use
> > >
> > > Does somebody know the correct place where these values are in
> > > the specs? Section 7.3.2.19 is about "Supported channels IE".
> > >
> > >
> > > > > > +  *        47, 94, 63, 0 here? Also, the default AIFS
> > > > > > +  *        values (second parameter) are 2, 2, 3, 7...
> > > > > > +  */
> > >
> > >
> >  7.3.2.29 EDCA Parameter Set element

Sorry, typo, I actually added the correct reference to the mac80211
header file :)

johannes

--=-QGujRpmSjfgSNn3AFMeI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7LeL6Vg1VMiehFYAQKWBA//fI/PyaB6ASWZIHvIe4b3ITxIrjDqefK7
MBqgAlCn8e9bxvr/79gJkNaymub/tQkQtF8X1Id/wJ5SKOwQTKm8TtgGLt4GzMdr
7o3DAufJyWHgxe/HA01vIPRps6pAX2iUdovn9+6Eyjpy4Y6La2qSKqB7+lggcv7x
Tfwv7z+P7S2hsR/YNxiyFYbyQCHbICdqqs8sZJQN7RHNhGFu1wYh39R3SEeYk5lJ
iiw3oBT7WTv/AJ/S8CYqsDnlK7t+pGOCnn9P/AKtJWcGAWZ9FJ120H4iQz8sx60q
3FWPI8Kccs+IeRRraKI+C1O9rWzHPNwtlXfhPY9MtZFnreoMKH5aykQkKKZ7D4qx
JCeIPUifzKNpJNLgejQP7spuXfKw35V8jNH63grn1z0Qw3bBk3dR84IVYi44HO5h
MxsmewMKA/kfJ7KEJT3AAHwlVIX/tu2hYBIuv47oWuKUQWA7CbVRrh9NOlIgRUeA
9RBvOvUTsWHjpcsSVQjU0/E+PjFv0BqhBH6yocGgBPOsgrDHETc1WmkxbMmkOxDA
wMPiVr9vkU2x3B/WOsrA/bp10EvlAQ6ZAr9WiOwR+zU1L7VmJPNxOUdmsfSWFC8p
AdlZn63QKwHn3Imz087im1G4qMyZmRtJw0F28t7AxaM1YPP+wPnT0fM/9IqNhs1F
JAkv1u3AnRk=
=l7o3
-----END PGP SIGNATURE-----

--=-QGujRpmSjfgSNn3AFMeI--

