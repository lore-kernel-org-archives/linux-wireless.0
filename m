Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbXHALx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 07:53:29 -0400
Subject: Re: Rate control over multiple devices
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <20070801134624.481eb856@griffin.suse.cz>
References: <46AFB779.4040003@warmcat.com>
	 <20070801004543.GD4719@tuxdriver.com>
	 <1185960764.14279.2.camel@johannes.berg>
	 <20070801134624.481eb856@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7c+Q/uvf/VsPCV3jXPWP"
Date: Wed, 01 Aug 2007 13:54:15 +0200
Message-Id: <1185969255.21901.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7c+Q/uvf/VsPCV3jXPWP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-01 at 13:46 +0200, Jiri Benc wrote:

> Exactly. This is one of things that should be solved in the patch
> mentioned below.

I suppose you mean this patch
http://article.gmane.org/gmane.linux.kernel.wireless.general/2303

> > Apply the patch already? IIRC James made a pretty good one around that
> > time to let the driver choose a default name as part of the hw structur=
e
> > it registers and it can be NULL for the default.
> >=20
> > Of course, in a perfect world we'd have a 'default' rate control settin=
g
> > somewhere and apply that for drivers that have rate_control=3D=3DNULL, =
while
> > default would default to 'simple' to avoid the issue above.
>=20
> I'd really like to see that in the patch. Seems to be a real issue.

Except that we have no API for that (should be in cfg80211.)

johannes

--=-7c+Q/uvf/VsPCV3jXPWP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsHRn/ETPhpq3jKURApJ9AJ4kFBXOiALvsBxTlYfuBUkopcNUDACeMEra
XDuiVLhMDxNCHPkdR5McZ3o=
=DqQd
-----END PGP SIGNATURE-----

--=-7c+Q/uvf/VsPCV3jXPWP--

