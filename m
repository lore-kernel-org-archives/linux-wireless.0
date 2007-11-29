Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXK2JVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 04:21:53 -0500
Subject: Re: [PATCH 1/2] mac80211: set interface MAC address after driver's
	start() is called
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1196327209.7614.113.camel@debian.sh.intel.com>
References: <1196300047-6201-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20071129_013615_457152_DDE3939F)  <1196326174.6058.173.camel@johannes.berg>
	 <1196327209.7614.113.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RKUMHOnRf+cOMpWghDfb"
Date: Thu, 29 Nov 2007 10:21:38 +0100
Message-Id: <1196328099.6058.175.camel@johannes.berg> (sfid-20071129_092157_921604_7E66EA42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RKUMHOnRf+cOMpWghDfb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2007-11-29 at 17:06 +0800, Zhu Yi wrote:
> On Thu, 2007-11-29 at 09:49 +0100, Johannes Berg wrote:
> > This cannot possibly work We do a lot of MAC address sanity checking
> > at _open() time *before* the place where you inserted the MAC address
> > copy.
>=20
> I tested the patch. It works.

I know it "works". But it doesn't work when there are multiple virtual
interfaces etc.

> Anyway, Tomas pointed my assert for "iwlwifi cannot get MAC address
> without firmware being loaded first" is not true. So I don't need to
> change mac80211 to adapt this any more (not sure if other driver
> requires). An updated patch for iwlwifi will be sent shortly.

Great.

johannes

--=-RKUMHOnRf+cOMpWghDfb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR06EoaVg1VMiehFYAQITdw//YVPihOOZraED0PpMlmCI2zWfDKoZSgmf
oo4k0oiQriS+U4Db9VSVPLSCLUZLOaQ7gGbmsfSugs2WvK00ERl+FLuFPHRkAipa
C47Od3jptx5LbQW3hDeJpUrt5DCHFWw9edy0mElEtN7pYkgTCNQu+Ab1YyJjs347
uwdu6A/Oq1XynQGnNLit3Zl8aDT1QANW/criK+dh2qXLa4lVjccrXLmBIod610wh
pu+vvHtTezevq0hVzVuGEk81T3BzI/YV3gDu30O9039i3M5gPPakREv5ps7KQGEF
J+Xu3bFUPk4/a868ooWjJLjtcCKJUMqPBakgKhy/mu6PV73RyrkWTPU7oh3lIScb
hFgUECFVqFfDuh+WjMiB6zFeik7fksz2h/royiW6xFxutTGvIbIfPzJt7l3no8P1
UFOBcnlEBCK0C9xvL9pxGQuk+EoHp+cF0mCSahKZJXF7mNuMNEJvj+OE8QXWaD/3
lCEZzTg76IG+cuhS4aoFbCq7nrcvUZd6rN0hj7nbFAK50R6pKcs3MuzTL8l8gr1X
c5zehdt4vFX1EsXvEpQoPBSbX7xLmAL/g6uthVPDNJnnwlWDs0wFjP2DDWlr6pIc
nCZuY2TZpxSiLuzIF+nIldPlhtTlNwVMuWjd532AYkRvlEdrzz5kydHg8mDW9kC4
QNK9ycNf+Ac=
=h/AX
-----END PGP SIGNATURE-----

--=-RKUMHOnRf+cOMpWghDfb--

