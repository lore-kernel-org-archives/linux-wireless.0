Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXLRMkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 07:40:49 -0500
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712180124l422c04d1g5ab3a8f67e245199@mail.gmail.com> (sfid-20071218_092414_004268_0154E53C)
References: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
	 <1197913576.4885.57.camel@johannes.berg>
	 <c85cb4470712180124l422c04d1g5ab3a8f67e245199@mail.gmail.com>
	 (sfid-20071218_092414_004268_0154E53C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UhDTYWkyddZTzqndFuVE"
Date: Tue, 18 Dec 2007 13:39:57 +0100
Message-Id: <1197981597.4885.111.camel@johannes.berg> (sfid-20071218_124051_907106_6D0693AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UhDTYWkyddZTzqndFuVE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-18 at 11:24 +0200, Ron Rindjunsky wrote:
> > > +     if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
> > > +             return TXRX_DROP;
> >
> > Should we maybe do the test explicitly for when we want it, i.e.
> > AP/VLAN/IBSS cases? Just thinking of the mesh networking stuff etc.
> > that's being added...
>=20
> no problem, i'll send it over. currently i see only AP mode as relevant.

But I think that if we have a station in a VLAN then we'll have the VLAN
interface at this point, no? I guess we really need to test that anyway,
I wish hostapd could do VLANs without RADIUS.

johannes

--=-UhDTYWkyddZTzqndFuVE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2e/nKVg1VMiehFYAQJf+g//etYNRqYRsi0+U43boKQ4du2+Deo99EJH
UfSSUbV2C8A/LVuOux4UXhTgitMs4ktryeWiCYhCsig7dUvOzA4q9RYU1MzQ0Lyd
mLg5zCC7d/KRE75k2mol4FkHSp9SQZb9EXE1V8hYTa9+4yE5YgO2LerpewSqKwMG
HLSo4eGnOaaYp8KnYFb8qsWsIVKsY2MKXnzXsSZuL9Bf0Osauhc4IcZ7MQdoxyKU
Cr5w76TIUOH6RNIbpJ4b4WMlyPEnsSItRWYtjSyXXrKmrpVA8HCdOT/CAsOl0Vaz
vMHCav2M0Dz7hX2z/SkccDjsLY036Zznb1P7YPhmenopzCP2nlftoeVIdA39p7zK
p63tgz5NgwbvYXi7MC4gG0oUZlCq8a22whVlyOhgMKtMteHKwp684fFVtfm4gVtO
5GbcR3NxpXc7ftOV0ogdGJlp37ADL/SC5Rv4suD57MHCXmsulz5fwY9jnAZ4Dd5u
o5JIF5l0D2AasHczSuLz6sjF06qrDahIXXpgLj5acdEuo5LMq26DCNwEEOsEAe+V
627sqv8qeoBvi/6v46rrWbmImC2Xy84HUK7YJvIwSBJ+cMfcMxHhihDguvfVdj9W
jr0oKoEpS/LQijB7n62gPMwidT+Qs2mEhuX5/ldq6E7MhC0my1OEmJ205b9ubfdA
kX14az42L+I=
=rgGB
-----END PGP SIGNATURE-----

--=-UhDTYWkyddZTzqndFuVE--

