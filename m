Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbZEOIXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 04:23:40 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>, Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090515012710.GC21718@khazad-dum.debian.net>
References: <1242030669.6930.10.camel@johannes.local>
	 <4A09B130.9000106@gmail.com>
	 <1242151180.3203.19.camel@localhost.localdomain>
	 <1242151479.11924.4.camel@johannes.local>
	 <20090513214004.GE26299@khazad-dum.debian.net>
	 <1242253192.10076.3.camel@johannes.local>
	 <20090515012710.GC21718@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sss0PAFvQfSkqwCiYmGY"
Date: Fri, 15 May 2009 10:23:08 +0200
Message-Id: <1242375788.5799.40.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sss0PAFvQfSkqwCiYmGY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 22:27 -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 14 May 2009, Johannes Berg wrote:
> > > As for the issue Dan reported, I have _no_ _idea_ of what it might be
> > > causing it, and a bissect would help wonders.  It will have to be fix=
ed
> > > anyway (even if it is also fixed by the rfkill rewrite) if it is hosi=
ng
> > > 2.6.30 :-(
> >=20
> > Dan? Now I'm confused? You mean Will's issue? Does thinkpad do LED
>=20
> Probably.
>=20
> > stuff? That's the only thing we changed recently in the current rfkill
>=20
> Yes, thinkpad does LED stuff... but not on the rfkill path I think.
> Although one could certainly use a rfkill trigger on one of the thinkpad
> leds, and that would tie the two together...

Exactly. But for some reason I fail to comprehend rfkill had LED
triggers but never actually used them until Larry very recently added
that.

johannes

--=-sss0PAFvQfSkqwCiYmGY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDSZnAAoJEODzc/N7+QmaDBMP/1TeQlyDTiHH+E0WFezJM1+x
qOSTjy/nGfsM3ZclzrtCRU2g4PIIbcYD7/l0oxf1osgVyIc7H5aQ5Jsoky+bWC50
VEd0hZUl+RND+BAEgAxynvsXnfZg9HjXqBqeTki60j//L3smW1XzkbnyvHS1EmmN
hq/KYpJYHJGXSXkNF/k0MNT2GHTqkVmMityBFkNQPRGz6kpXIbt+f3wJSMhdBBS+
Vhb+SkROyYFx/ZWEpX22zAyCO/9apgQj32iiQRry2AiuXCKu5rlyciBuVj80unCu
AWB+5Wd3eEhp3oqX5W1S9B8D+I18KCxaL+HDGn5xn+XgTuLSEkO9g/M/WexqUsax
slAo9WEFNZ8s31H8sO8Gul4N4e4eTSytEupKSULoXvlOBGxy4ufhKXIYwtdb76Ty
x92YoQsHnpvKwyEw50s3DCfgmRXz1w6M/vCgVNBU4m6Vy4nv0FH6fbT/QftcumMh
w6LrWB/jRdBDVzJ8rHjxhwIcBfiXa8fPL78+l/GFv3vmPLKToo/zENo7kh9GXc0T
QuJbhhNgt3jZqJOeYxnVeOd/rC9/kOr40gpRFle5nBeBldS8xPRmdCd4hdabMQBL
4+WBfX8hLe9bbdAnlHwz+9SC88xrFoViSwihQfLlPXtlJ7Iz/VDMQ+Ml/7icVmn0
cnAluZG0f6LWBcYdnyH7
=QFtq
-----END PGP SIGNATURE-----

--=-sss0PAFvQfSkqwCiYmGY--

