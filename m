Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946100AbXBPWMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 17:12:17 -0500
Subject: Re: [PATCH v2] d80211: Add software sequence support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702162307.16826.IvDoorn@gmail.com>
References: <200702141423.27823.IvDoorn@gmail.com>
	 <20070216135827.7d262ae3@griffin.suse.cz>
	 <1171660484.3575.34.camel@johannes.berg>
	 <200702162307.16826.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GC+pk7KacA7yTW1UiqbZ"
Date: Fri, 16 Feb 2007 23:12:06 +0100
Message-Id: <1171663926.3575.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GC+pk7KacA7yTW1UiqbZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-16 at 23:07 +0100, Ivo van Doorn wrote:
> On Friday 16 February 2007 22:14, Johannes Berg wrote:
> > On Fri, 2007-02-16 at 13:58 +0100, Jiri Benc wrote:
> >=20
> > > Both.
> > >=20
> > > When you have a WDS link and some other wireless interface at the sam=
e
> > > time, their source addresses are (in most cases) the same. You want t=
o
> > > have the sequence control counter shared by them. Actually, it will
> > > probably work most of time even when they have different counters. Th=
e
> > > situation where it won't work is if you have two virtual interfaces,
> > > one in STA and second in WDS mode, both connected to the same AP. I
> > > can't figure out how this particular setup could be useful but it's
> > > generally not disallowed.
> > >=20
> > > Anyway, using different counter for a WDS interface probably violates
> > > 802.11 (although it's not much specific in this case). I believe it
> > > will work in most cases, though.
> > >=20
> > > Any ideas how to solve that?
> >=20
> > Make the counter per-mac address?
>=20
> Wouldn't that be the same as per-interface?

Don't WDS interfaces have the same MAC as the corresponding AP
interface?

johannes

--=-GC+pk7KacA7yTW1UiqbZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1iw2/ETPhpq3jKURAsx7AJ94Q7dAvFIPyX9bWPaCkflDcMuwQwCeP71w
+tLjsFs+WwK2s5wa6SbhOxc=
=H9m1
-----END PGP SIGNATURE-----

--=-GC+pk7KacA7yTW1UiqbZ--

