Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJXS1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:27:09 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>, John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20081024101518.GB5951@tesla>
References: <1224585110.5521.8.camel@johannes.berg>
	 <1224816184.2917.162.camel@debian.sh.intel.com>
	 <1224841176.6002.124.camel@johannes.berg>  <20081024101518.GB5951@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-01O/BS1cTyTRBUVMxY8B"
Date: Fri, 24 Oct 2008 20:26:20 +0200
Message-Id: <1224872780.3919.3.camel@johannes.berg> (sfid-20081024_202714_019882_6D24DB2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-01O/BS1cTyTRBUVMxY8B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 03:15 -0700, Luis R. Rodriguez wrote:

> >  * if a wiphy has the "hw regulatory" flag set and the
> >    cfg80211_regdomain is the world regdomain (whether hard-coded or
> >    gotten from CRDA)
>=20
> And if initiator =3D=3D CORE

Makes sense, yeah.


> This will not be a problem if distributions end up asking to
> set regdomain for a country for the user, which I think they should.

Right.

I'll post the patches that rework the current stuff and remove the
struct hint, and then we can implement this on top.

johannes

--=-01O/BS1cTyTRBUVMxY8B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAhNJAAoJEKVg1VMiehFYoKgQAKxJAk79nUf679CjyIoCieoG
H+IKmMH+b0Knywr1HO2fo/E+iSbLcn6tpLez2lFdP+EIXsH/ofPdxV3U+sRGrU0w
w1DDGemC/s8vWLHam+qKH8FnJ4egnZiQWW5ZxgQ1ytIw3QzxpYKJ7DRyB0M2mTHy
aPwJfwgiScpZ/qhtnhsHowfsigcL6EKpnzjQi5YTDjDUlQK79dqGs3nJ5nfW3630
UayLViu9HqzG9/4lxcSC6NNs3gHOrazdALIhl0+xVvD0A291JuvUp3NLL7gS7125
xwv9qQP+MAwCh9gkTKhVORlSNpIdLNM6XSnWZzVvanTQ29gEaCslu3uF9ILT9Le5
/0DjcQF2lB6KY78QKr7Iruq/7jNWh7v/sOpCvH1x/w4HfeHuohdbj0K+loazpwuy
nS1G1pZ5i4gy3hiFx6JU61Nbc3tDULHXXefnqEixmjRuElq5iP2NJLrnZmoGj8CV
u2Y1b8hkf9bg1+kYh+DyZNqTR1mY0Rs4DIMwRQ2G3wIwYmYJ4VpGj99juwcMhFMQ
BPAp5LAgnzrT6Z6TR4rfVSKtnENfOX5pAlSiZRjWGvjwU6qBoJRzETJAnNuT7yFx
k2uMXWobF8KFQwQnRgZ5FZE5R+lGyWzwvvhM2Bmb+uFrDRkQOmkrZ0z+5qJtechE
x3Xa9eNSlna4EeiV+zZ8
=RA3A
-----END PGP SIGNATURE-----

--=-01O/BS1cTyTRBUVMxY8B--

