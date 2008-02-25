Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbYBYTcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:32:39 -0500
Subject: Re: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh
	interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203967945.6929.17.camel@localhost> (sfid-20080225_193048_901987_FFAAAB59)
References: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
	 (sfid-20080222_071830_924260_34482369)  <1203696983.7082.63.camel@johannes.berg>
	 <1203967945.6929.17.camel@localhost> (sfid-20080225_193048_901987_FFAAAB59)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gb6W3FbM/gSt55Q40vwq"
Date: Mon, 25 Feb 2008 20:32:32 +0100
Message-Id: <1203967952.13162.138.camel@johannes.berg> (sfid-20080225_193242_560642_69FE30A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gb6W3FbM/gSt55Q40vwq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 11:32 -0800, Luis Carlos Cobo wrote:
> On Fri, 2008-02-22 at 17:16 +0100, Johannes Berg wrote:
> > >  	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_STA &&
> > >  	    sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
> > > +	    sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT &&
> > >  	    sdata->vif.type !=3D IEEE80211_IF_TYPE_AP)
> > >  		return -EOPNOTSUPP;
> >=20
> > Why no scanning on mesh interfaces?
>=20
> ? That's actually allowing mesh interfaces to scan.

D'oh. Yeah I'm confused here, sorry, was probably reading too quickly.

johannes

--=-gb6W3FbM/gSt55Q40vwq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MXz6Vg1VMiehFYAQJ9bQ//Reg67xrTx2F57No03oyWOIBzrFNzX9Bn
6H5rK04llu8IKX69zTXjUVI91faYPEa4n/yZsvocs94j2Cr6HVRkapzW0Ae7AoV+
gAPpNnuIVai5My4iTgvq1Y4EXBLskq9M8CsyM1uydIQgNe3P7gG4gDLUHwtswAZV
tDWJgS2+qayRBbcOI5d6Cwo1Y5o5phsqErauaao9MVdsTqJ/8e3kMmtVX95xT57U
3U/luuuPmmGfrPbMKMLsHDbCBcClVC3MmM1kpZRIEqfkmt3upx0pJLNdV+e0QhMO
OJy6mOi7riVf8mE6jx+JtNXmJveZhrbdRaewhCZMG0mmgB9vfDhvmyaLRquir837
Voog3aNAUFvGQQ8jvmL+2SXo9CKUKq2NqpmnIcR6m61tuEfmuX1olb1lKB+DBOGh
iqk32VQQK01NhVylWvHCMH3T6yl6+kSiUDEtx1amby8BKLjgaKRqwOg/Z7Rfzk32
AmHVYIdHGAVrJnL4YzyKf7vSl1xTarvJKXK+xRz9p03RbE9oyoShQrXkFnC3te9C
2e7VBc0rUg+ANo3eluoLysG+VCkJ+D5OO4DooGgo60ylpP49vn0hs1fGRsxQdvrV
6qhGc+uoJOJxvZstN885noZAHWU27RUJBmW2LVsjCFC5/E7fWIIBYO+pREeOhG9+
0IdJb9/vVBo=
=n6IQ
-----END PGP SIGNATURE-----

--=-gb6W3FbM/gSt55Q40vwq--

