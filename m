Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765333AbXJZUkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:40:52 -0400
Subject: Re: [FYI] hostapd state with mac80211 on linux
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chuck Tuffli <CTuffli@dspg.com>, hostap <hostap@shmoo.com>,
	Alexander Kotelnikov <sacha@myxomop.com>
In-Reply-To: <1193413588.2026.6.camel@dv>
References: <1193338400.4406.4.camel@johannes.berg>
	 <1193413588.2026.6.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mWBO6wsqeSVPMDrjDFcZ"
Date: Fri, 26 Oct 2007 22:42:11 +0200
Message-Id: <1193431331.15686.10.camel@johannes.berg> (sfid-20071026_214119_337491_06D62AB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mWBO6wsqeSVPMDrjDFcZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > hostapd works with
> >  - kernel 2.6.24-rc1
> >  - plus my patches from http://johannes.sipsolutions.net/patches/kernel=
/all/
> >  - plus the commit 5c58298c2536252ab95aa2b1497ab47eb878ca5d from net-2.=
6
> >    ([NETLINK]: Fix ACK processing after netlink_dump_start)
>=20
> Great, thank you!  Can we have all the above in one place in a publicly
> available git repository, please?

No, frankly, I'm too lazy to rebase git all the time. There's a patch
tarball you can download, untar and use with quilt.

> >  - my hostapd patches from http://johannes.sipsolutions.net/patches/hos=
tap/all/
>=20
> And this too, if possible.  Maybe we could have this in hostap master
> branch?  All patches except 004 affect the devicescape driver only, and
> 004 looks benign to me.

Similarly, I don't see the point. I don't want these merged into hostapd
yet because the API I'm coming up with isn't finalised, I'm going to
rewrite the beaconing API for sure.

johannes

--=-mWBO6wsqeSVPMDrjDFcZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyJRIqVg1VMiehFYAQL6oRAAw7ZLB7SE94yJFS3PDPLPmX6LXejt0ygt
rG0pBo1xGOyjt/LJUATc8eY1LijrYHPUaWOQnZ/vE+TpEMeJ2cTYl+l/2Z7wX9zv
7vhY0fwpqkeQcndqG8/ZMgok/sB3ZpCqx2zUXpB580RrmVnzPscEZafKhOIwM2+H
Fue+05WetLSHF99emJw5k++d3lIkuGIBSoHMFRs0WXF+v/zx3ujVzMNyUeBJShF8
AZeriy3vdMp8ixHRuFxKgfrv3tz18k49kGT6Fvt+uspMvHNdHJKHMQaEv4apqRw6
8fYkPmn3ut3ZVqP1eyRoPfzce5Y0G5tGpV246OxwZbvQ3rmm34TeCqmG/LpvzK4d
j7hXQik4EQvc1eXEydHBEJ6J/TMywo+QcnT4ZKrOIf5As8oPvQVTKijMDdln4PZg
UeN5ddq4Lo7iuKrVd39FoKnaf6MyAJ3lvOZpiKagBrclpQgiKzdw31ECQLFwN0JN
UU3lGCVLzaEbc/cFRmX7dhVrvRLtk7WCxTK0v8FX3dXhhOUWBFqEAoNJAVIvGGmN
H2dD8IJBICD2e3dNhiXVSf5fRmU0Tb4DLtcnglnWifwgTyGc7MJaoPi7vg7UW3RT
ito0JUTYwXhUoevTpg0x/ZJsY5e4k7fveVYgrAkso9q1O8ldvwX8XjGLVjmSdLGc
SHdAiZANQsU=
=Bx51
-----END PGP SIGNATURE-----

--=-mWBO6wsqeSVPMDrjDFcZ--

