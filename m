Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbYECOHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 10:07:10 -0400
Subject: Re: [PATCH] mac80211: use 4-byte mesh sequence number
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1209823326.3987.32.camel@johannes.berg> (sfid-20080503_160150_265232_3CC71283)
References: <480f9318.0b35640a.0a3f.ffffc3eb@mx.google.com>
	 (sfid-20080423_215126_615548_B37D1180)  <1209823326.3987.32.camel@johannes.berg>
	 (sfid-20080503_160150_265232_3CC71283)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g4EFI0mAfRBKZAlZ/Wvs"
Date: Sat, 03 May 2008 16:07:02 +0200
Message-Id: <1209823622.3987.34.camel@johannes.berg> (sfid-20080503_160642_879384_C503F2FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g4EFI0mAfRBKZAlZ/Wvs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-03 at 16:02 +0200, Johannes Berg wrote:
> On Wed, 2008-04-23 at 12:15 -0700, Luis Carlos Cobo wrote:
> > This follows the new 802.11s/D2.0 draft.
>=20
> Umm, I just realised that
>=20
> >  include/linux/ieee80211.h  |    2 +-
> >  net/mac80211/ieee80211_i.h |    2 +-
> >  net/mac80211/mesh.c        |   17 +++++------------
> >  net/mac80211/mesh.h        |    2 +-
> >  4 files changed, 8 insertions(+), 15 deletions(-)
>=20
> This doesn't change ieee80211_get_mesh_hdrlen. Isn't that missing? Can
> you send an add-on patch (since this one has been merged)?

And the return value of ieee80211_new_mesh_header as well.

johannes

--=-g4EFI0mAfRBKZAlZ/Wvs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBxxhaVg1VMiehFYAQL1wA//T8Mmt9VAHQXZUGPEp1SNT6gK4QL2C6g2
BiFuOI+FfFKadyvNJ02sP59LTO1Z+1fqnYb4yvd/Nni1I0En0hObpyn2eeFdlFyk
YnQ6bEq1hRqgUojoyZOOTr3RrnUr7yhxgHJ20Z3D5Xt4fnOhzWvhIrtkLipxV1P4
gjIOIhI7RYpBF2CbgsfoE2o1MmZY+UpvaUWk7HtvfSlcd/Ke3jjAu8x5qywcudwG
AzHPEGpEDdp1I2ErplNXQ1/chCKBDAV6NAHLHMoUZMtbv7HnOqeC1uK2nC9IAdNg
q+v1VYIwVJB3BsZElXOLkQFRbYHvbi+60joggKyPuKYmFDUPtNwTiJvb1VK9URq2
XrU66bNZcX78NCPlmW5dRu+VLWjCs23QW4d1IzgvX1/1I277w0VjYjhy6wlTn/Ac
DiQkT8VQc8hkLW5FXzBos17y+ceRFUXqedn0U8oUwUXtKBBik2P+Op2ZmfOgv4Sy
Bf0rgix/5FpjVq7FYX+S4UZJeI4una1mq8o/Xlhov0hAJ55C7hxmRQrbhn0KmPWQ
2tBAC5ddpfvEEP8XkLIGpdg4xpzDbdEUYBOZBgwYFX/Q03yJeS2eLYqKQxccOvdO
q72qc2bf4pDzyr90Wbeb3Y6Nnw0jjyEyZwz6xyF/PlLBl9UMP9M/4QJsRRpGEzp2
hfBUH1gum48=
=skYz
-----END PGP SIGNATURE-----

--=-g4EFI0mAfRBKZAlZ/Wvs--

