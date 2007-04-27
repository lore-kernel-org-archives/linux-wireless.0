Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbXD0P3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:29:44 -0400
Subject: Re: [PATCH] mac80211: add sta item when changing WDS address
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070427172332.0d69f013@griffin.suse.cz>
References: <1175011277.9282.8.camel@johannes.berg>
	 <1177686772.3565.32.camel@johannes.berg>
	 <20070427172332.0d69f013@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0IulF+7i3XYjbBIYeK8m"
Date: Fri, 27 Apr 2007 17:29:46 +0200
Message-Id: <1177687787.3565.44.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0IulF+7i3XYjbBIYeK8m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 17:23 +0200, Jiri Benc wrote:
> On Fri, 27 Apr 2007 17:12:52 +0200, Johannes Berg wrote:
> > On Tue, 2007-03-27 at 18:01 +0200, Johannes Berg wrote:
> > > This patch adds a sta item for the new address when you change a WDS
> > > link's address. If the sta item cannot be created return an error.
> >=20
> > Anything wrong with this patch? :)
>=20
> It's in wireless-dev for quite some time (commit
> d80bb18ca3444520b465f3006bbb78837a5e28d9). Did I miss some problem when
> I was looking at the patch?

No no! I just thought it wasn't because quilt managed to apply the patch
over it being applied already and so it was still in my patch queue.

johannes

--=-0IulF+7i3XYjbBIYeK8m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMhbq/ETPhpq3jKURAo4MAJ45f03aPVRIayJU2orFgm+1xYW1owCcCNm4
fysp3HFQcNlUpH7uoeDIdd4=
=tSXX
-----END PGP SIGNATURE-----

--=-0IulF+7i3XYjbBIYeK8m--

