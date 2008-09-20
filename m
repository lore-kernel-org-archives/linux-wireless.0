Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYITVDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:03:00 -0400
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for
	Motorola 7010 variant of BCM4306
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, bbullins@triad.rr.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <43e72e890809201359kb65f3d3qb618129ae6b528f4@mail.gmail.com> (sfid-20080920_225942_127028_DB247EB0)
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
	 <200809201744.55571.mb@bu3sch.de> <1221943895.3023.1.camel@johannes.berg>
	 <43e72e890809201359kb65f3d3qb618129ae6b528f4@mail.gmail.com>
	 (sfid-20080920_225942_127028_DB247EB0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o+kXQtgoo531ZIqdF8hP"
Date: Sat, 20 Sep 2008 23:02:55 +0200
Message-Id: <1221944575.3023.10.camel@johannes.berg> (sfid-20080920_230304_164973_0E721979)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o+kXQtgoo531ZIqdF8hP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-20 at 13:59 -0700, Luis R. Rodriguez wrote:
> On Sat, Sep 20, 2008 at 1:51 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2008-09-20 at 17:44 +0200, Michael Buesch wrote:
> >> On Friday 19 September 2008 21:47:38 Larry Finger wrote:
> >> > An additional BCM4306 has been found with the Bluetooth coexistence
> >> > SPROM coding error.
> >
> > Does anyone actually make laptops that use these bluetooth coexistence
> > pins? All CSR bluetooth chips do it automatically I'm told, maybe we
> > should just kill them completely.
>=20
> Regardless of the wireless card? Or just for bcm?

Well just for b43(legacy), but out of curiosity, does any BT chip use
these pins anyway? Well I guess _somebody_ has to buy BCMs BT chips,
but ...

johannes

--=-o+kXQtgoo531ZIqdF8hP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1WT6AAoJEKVg1VMiehFYNQ8P/3KNMxB21wm+hQPoZXK86svb
hDj5UYisro+a3ArZN2FrBvuRn1U6i5DcRILi+ZQUAxsx7diTgduexlFRTXHwaNiA
T5fvQzeSi96nKKhaIDphtZQDqquQl7/r59H90P38XtNm8qRl0LjGfmVJmrehiGnz
QCiOk4sxL2zmuRuCiyyAk6Ae5OGbHCyvAZIr17/9f3cOOyahPDBInN3uti79Ecj7
PfreTvT3XDEfsN22P1RxjVFWpCl/fllGIzM1mSOmRzst6HM1OIjM7pyD9GFtMDn6
O7+slulFZu+A2F37kLwR0sKAAGZPIt35hsxr+jPou8eENN5N1Ihwpcnb1pG+GqhE
O6w9Z8/6zDWdorPhG08R74lfrbv2royTFRCf9YXNahQAjoaVr6tDgnIAK4BvuSuV
AGDEp8s8olIgitzLC6FcFe1SOHknGXwQshAEzPHOcJhBY8KjPyMyzWZrphG6HPWU
pRFYhM6b05jQn+Q3zIgDaLnvxgux3dzIP45rya1dyE1BKmYv2phZdQxkFCtJfqAZ
sN34VGUkoz0GenXfq0juQgoGHMTpoTtt1w12wW6GYThtY1zVdarTqjx0qh4OrTC+
lVZvWBAcEl1ZsWPxjb0L34oYW+QP5sHLqGt+OknVbFK7t9VE8CzDWijzhMIyoJ3v
vDlsg4lU8CPLQTci7sfo
=mFQa
-----END PGP SIGNATURE-----

--=-o+kXQtgoo531ZIqdF8hP--

