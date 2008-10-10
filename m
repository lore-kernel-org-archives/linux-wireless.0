Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41106 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762042AbYJJVoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 17:44:19 -0400
Subject: Re: [PATCH] nl80211: export HT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081010213610.GB20509@tuxdriver.com>
References: <1223547613.22490.41.camel@johannes.berg>
	 <20081009085747.GB11530@tesla> <1223630622.17594.0.camel@johannes.berg>
	 <20081010213610.GB20509@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TsvB04GytQXDZv2lmDiD"
Date: Fri, 10 Oct 2008 23:44:06 +0200
Message-Id: <1223675046.29811.0.camel@johannes.berg> (sfid-20081010_234424_083844_D5DA5AB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TsvB04GytQXDZv2lmDiD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 17:36 -0400, John W. Linville wrote:
> On Fri, Oct 10, 2008 at 11:23:42AM +0200, Johannes Berg wrote:
> > On Thu, 2008-10-09 at 01:57 -0700, Luis R. Rodriguez wrote:
> > > On Thu, Oct 09, 2008 at 03:20:13AM -0700, Johannes Berg wrote:
> > > > +#define NL80211_BAND_ATTR_HT_CAPA NL80211_BAND_ATTR_HT_CAPA
> > >=20
> > > Typo
> >=20
> > Hmm? Am I too dense?
>=20
> Well, it looks a little useless to define something as itself...

Yeah but you can use that to check "has the nl80211.h I'm compiling
against defined the HT stuff yet?"

johannes

--=-TsvB04GytQXDZv2lmDiD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI78yhAAoJEKVg1VMiehFYLhwP/A9YzblpLW2d1qMoni061vZh
Hz+FR1AnoBn++OOM2tXMoJivOdS59OlXi6pEsqRWT6AdyapCkorFrITFmhqdPRP1
FomLx4JBRwO4J2hCOmOQwXsyWUfW7TDMZgyiet5Al2mWCmw6gP0ESAy33KvYIXm3
kM03HG3RkoiREMb/tjfOIBUDBj6vYRP/uz/iXjOTAFGBOUBB34Ib10eriUMh1UTM
h5bqMuLbqmLhmrl4ETkCvPN2t7DeK81hhQ3CGXyjfBh9HT3+8YeydBgCtKaOfnGT
r1hdC9Ao35KMoe/FD8RUoxxfFJ/+X+colcHfauNetUVM/S0cwAxUPI3K5ANe7Ex3
KGnvrFI79AEXyZiR2Mvn8mf1Ecke47Y2jTsj/jwYk2MA1GXbkfEb/3ZB4TQ7ZGpZ
ieLp1QTX3NJioxcK8KJhJJ96en6mNTamu36bE5hwhLD8rMrU+U5j36n4dSmLfWRI
gXtWdFLnoRzKP/P8dC10AxTDzamXNZ95GTpgzMnF4tecVqAYA7L/06LqDzdL8keU
PE7giJkQNgMlCLBuVVYQ+nqOLWWYgbqRTziAb2eOGWi/s4ohak1ZI992kHrwkfkU
oaTJ0BtiCwn13kIJlYcBIkYqVeJicPgnOm08NZUfA96AY7Em8+QIzj3zMm+m1PHZ
zg/kc+MktRRzBQIRXSee
=jQYm
-----END PGP SIGNATURE-----

--=-TsvB04GytQXDZv2lmDiD--

