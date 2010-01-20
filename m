Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0ATSXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 13:23:33 -0500
Subject: Re: [PATCH] iw: add country IE parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1264011628.5591.211.camel@localhost.localdomain>
References: <1264009908-27195-1-git-send-email-lrodriguez@atheros.com>
	 <1264011628.5591.211.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3a7j1zSK0chpxS4H+S5D"
Date: Wed, 20 Jan 2010 19:23:29 +0100
Message-ID: <1264011809.11396.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3a7j1zSK0chpxS4H+S5D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-20 at 10:20 -0800, Marcel Holtmann wrote:

> > I've considered showing only the channel set from the Country IE
> > but since cfg80211 now mangles contigious channel sets together
> > it seems more useful for iw to just display the individual triplets
> > separately so this patch is left intact. The triplet print is
> > kept since technically speaking this should also show the
> > regulatory extension stuff when one is found.
>=20
> looks like this with my Apple Airport if anyone cares:
>=20
> 	Country: CA	Environment: Indoor/Outdoor
> 	Country IE triplets:
> 		Channels [1 - 11]

So I would still like to see it formatted as one
	Foo:
per IE, so in this case someting like

	Country: CA	Environment:
		 Channels [1 - 11]
etc.

johannes

--=-3a7j1zSK0chpxS4H+S5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLV0odAAoJEODzc/N7+Qmah6kP/1A4yBXmRk7uxTtcU96yMmvB
O1VFTpkbUI6+7EMhPnTHteQCTVZSMguLUSp5VuHsEXyN2urNRWbMBdrncCP2vCqv
1t9WslbyrJKWCkEzqzhlmnnmq8hJnSYYbK00C4SKulLESeq0yTO0kPD8ctxvm1FF
z/E/3i1U88kE9awyYE5zIbYP6o6rhPm4V8bmw+go0kJkICbCSzjF4Z4sFA8FMpWO
mzNpz1/9TMM1tMUYPJLzMnnXHrhNCVBZDXQ8V7ZPuQ/IZB+1QGkkkB5cY13ZvQCq
HuVKWquXIdRbQOTrgexRUQAqYZoKu8IhCcGxKObzE8duh3RDk6H5Z05QEyUqChLe
QhIn2eiYm1v8VQcDdCsGed8blY5tPNjzLtuGk1zpe+kXe+tfB30QxtPycY2h+N+N
VEzrricYkliKI1ef21K9chapr4N98i6ugVwjR8yMeG09NxStIQoNNCGtZWUnrKcT
K+vDgjSHUctNFcR8a0wOAdXYk86yKmKGyMRLYGBQArk5z9edJyRhZyGlpmwglrGc
1YKTigCNIZlTO0zzOIK7pmQANOL/4owsza5Xotd7UMlUiBgLroZEoBXJr2VKcjD3
HVbdt0Cb+NgR/YzCINR4EKk7m80znerQA5TJ5JFf+FElsehZeKgyyPIlW1zWuQFO
M6jhBKvJDnjNMZzqad+I
=6lwN
-----END PGP SIGNATURE-----

--=-3a7j1zSK0chpxS4H+S5D--

