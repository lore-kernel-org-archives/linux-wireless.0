Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYJFLkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 07:40:52 -0400
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables
	aireplay-ng and others to work
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Paul <paul14075@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223285497.2510.732.camel@debian.sh.intel.com>
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
	 <1222571710.2510.587.camel@debian.sh.intel.com>
	 <7d553cf40809280059v454023eaxc8a570fb6d4efcf@mail.gmail.com>
	 <7d553cf40809281228l13414507xc11e8e592493e43@mail.gmail.com>
	 <1223284316.2510.721.camel@debian.sh.intel.com>
	 (sfid-20081006_111343_274436_FA74EFEC)  <1223284624.24551.91.camel@johannes.berg>
	 <1223285497.2510.732.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CkMj+nSx0Fyenv8w5Jcp"
Date: Mon, 06 Oct 2008 13:40:14 +0200
Message-Id: <1223293214.15196.0.camel@johannes.berg> (sfid-20081006_134056_801704_B5D48135)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CkMj+nSx0Fyenv8w5Jcp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 17:31 +0800, Zhu Yi wrote:
> On Mon, 2008-10-06 at 03:17 -0600, Johannes Berg wrote:
> >=20
> > how about making use of cfg80211 to create the monitor interface to
> > start with?
>=20
> Nice try. It is not a mac80211 based driver.=20

I know.

> I don't know how much
> effort it takes. But it will be great if it works.=20

Well it's surely possible, just register a wiphy and implement the
callbacks you want like mac80211 does in net/mac80211/cfg.c.

> Maybe we can also
> replace ieee80211 with cfg80211 or lib80211 in the future? ;-)

Not really, though internalising ieee80211 into the ipw drivers would be
good.

johannes

--=-CkMj+nSx0Fyenv8w5Jcp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6fkaAAoJEKVg1VMiehFY3Y4P/i1ltewrEwqa79l5uzpLw06S
jZWF+je9kxTJh6E1V1r2FQ79VV8wXgIAAdRSWvSd0lFOPBXzvFLoZglatvD19d7a
OnlJ4rp6z0DBXeQkAQc1mtg1WIUbYr0n38QCf6stIdvrIIjSDdBcKNGK7avu7vmz
9paYtIm158WC1tzAy76bXXIiD3Meq+vOyTzhQdX2W7UMtXa8TK9ynbUiekI1DCNb
l62/ny4u1yeBgSUaVN7we+kQRmZ9K/+SYYZLg1PanjvWM9HhBw2ChewNYOmBZ9XU
YcGaJIlZvyOCVbN44iQVsqBkO5HRVVWJfPUbThIb0agSbL1Z46LVdP3T9r3fjjlV
6H2kf48ulWM6zC355JdMMFBCA7kPce0bpP3AxnPGrPH7XyZ5BknN5pgLHngMPu+R
QW+jhSZEmWXvDY3TnSduca6Lf/rzeAaPHneufCtgBRaJHElg/KhFgaGXekF3SXbr
9W9Kt6gvQTmg9JiwAeoIJB4uu1ckH22ru+C8xSzOYHeoRIb9lUeCsj4hEe8RfbXv
Ca/4RRNPNK8R1c98yAvScdJn9t0ukcfJd4WEajkxNb691v6gyPY7Q6AhwmRelCwY
f7v4nzT6fqGbzz1O5Y0jcmUhzOHIAAhgfEPx+2YkHaLIdrustXZKO82p7+Hznifj
wtSWtLhXocnbPRQF5J5p
=SpUW
-----END PGP SIGNATURE-----

--=-CkMj+nSx0Fyenv8w5Jcp--

