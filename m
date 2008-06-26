Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYFZSAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:00:45 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	cs010101@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <1214496086.30722.14.camel@dv>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <1214449044.18897.15.camel@dv> <1214487200.20763.44.camel@johannes.berg>
	 <1214492236.30044.7.camel@dv>
	 <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
	 <1214496086.30722.14.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OrpzkxF47HhQA8B2VIq3"
Date: Thu, 26 Jun 2008 19:27:22 +0200
Message-Id: <1214501242.3783.7.camel@johannes.berg> (sfid-20080626_200100_796829_6D11CA38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OrpzkxF47HhQA8B2VIq3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-26 at 12:01 -0400, Pavel Roskin wrote:
> On Thu, 2008-06-26 at 17:46 +0200, Stefanik G=C3=A1bor wrote:
>=20
> > Maybe we had more people working on/debugging AP mode if we didn't
> > intentionally disable the existing limited support for it... Possibly
> > print a big warning that "THIS IS NOT STANDARDS_COMPLIANT YET!", but
> > outright disabling it and requiring an external patch is IMHO stupid.
> > Perhaps a Kconfig option with EXPERIMENTAL and default=3Dn would be
> > better.
>=20
> I agree.  More people would be looking into AP support for individual
> drivers if mac80211 didn't need a patch.

Oh and I never answered to this. I disagree. Requiring people to patch
their kernel for AP mode support is a good way to discourage
"contributors" who don't even know how to compile a kernel, trust me,
I've seen a fair share of private mails from those (which I ignore: do
not mail me in private about AP support).

Hence, I don't want to do it for exactly this reason: a bunch of dumb
users will enable it either way, and actually _working_ on AP mode
_will_ require kernel patches, so this isn't one that matters.

johannes

--=-OrpzkxF47HhQA8B2VIq3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY9F3AAoJEKVg1VMiehFYypsQAMXh4PJV7VzxOxQ5YRBPsejN
8ihlZdzyZkdxfEx/x84gNv+142NIAGO7cxah557V9dhhq//H9Km1DaeqA1Al/Yud
N2ka2ujGBCSeg6iX5H2fXOwSATyjl2xSrDsHohbybF5T/acEu4FsjTjuyEVL52Kx
7xt07G+AgmV7syqP0iOiXx+jBvKGiHD/JIQY58j8bSDSJTShwvQXvMtWegNf/73Y
tIhx28tvvCDVqJIkYThPw/XDViAqkiU+grUltortSQFUqnRBnsMZbo2jwlI+eBjE
jnT27QG/ey5QHN8qmEiYXN0zf2TXaW+TWyjUrw7yJJs6vMYyc8drXFs5mFoGZRVD
frs/fDuf6loBMqu0K2tPce3HbQblJfLXToNDj9l4/oPMnVL2YTsW3LH4Blt8NMDV
JSwXp+GvM0PKv9V3/pJrLU2ZFuBgi743E6Q8cXhn7dUy4KJJPkPuRDtChx5hcBsl
DMUEDdIQ4c3T8fer9/mJYbTRe4qZdxa8ebSG8uP341/GoK+L1xR6jAKTE+qxSS59
e/NhtBmu4chZBW9C2HnnXZM5TkZ7xDEtTRmkFJ6iZKVdr1O9Nvdnl+6lP092djW+
+DVISRN28K12vOKcyUzNGTn25MzIm9nu73m7256lYDt5xUU/ZILX0eJEJQtB43mT
m6KQCy8TuyFUjTgwMr+S
=fL26
-----END PGP SIGNATURE-----

--=-OrpzkxF47HhQA8B2VIq3--

