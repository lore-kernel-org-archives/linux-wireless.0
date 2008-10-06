Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYJFMhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 08:37:01 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223296359.15196.8.camel@johannes.berg> (sfid-20081006_143329_031518_3AA03EA8)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)  <1223296221.15196.6.camel@johannes.berg>
	 (sfid-20081006_143057_986057_BC4A63C0)  <1223296359.15196.8.camel@johannes.berg>
	 (sfid-20081006_143329_031518_3AA03EA8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wb0yGArfRonz/43Ol7Qg"
Date: Mon, 06 Oct 2008 14:36:29 +0200
Message-Id: <1223296589.15196.10.camel@johannes.berg> (sfid-20081006_143706_741422_4A3FA860)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wb0yGArfRonz/43Ol7Qg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 14:32 +0200, Johannes Berg wrote:
> On Mon, 2008-10-06 at 14:30 +0200, Johannes Berg wrote:
> > On Fri, 2008-09-12 at 04:10 +0200, Marcel Holtmann wrote:
> >=20
> > > I take this back. It took a couple of hours, but it crashed again.
> >=20
> > Do you have 64k pages enabled? My issue goes away entirely when I
> > disable 64k pages.
>=20
> Well, clearly not entirely. But it's holding up much better now.
>=20
> [  325.379292] iommu_free: invalid entry
> [  325.379309] 	entry     =3D 0x848c0
> [  325.379315] 	dma_addr  =3D 0x848c0100
> [  325.379321] 	Table     =3D 0xc00000000083f348
> [  325.379328] 	bus#      =3D 0x0
> [  325.379333] 	size      =3D 0x80000
> [  325.379339] 	startOff  =3D 0x0
> [  325.379345] 	index     =3D 0x0

and that keeps happening while I use wireless.

johannes

--=-Wb0yGArfRonz/43Ol7Qg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6gZKAAoJEKVg1VMiehFYSj8P+gKPvRqNAHUGI0uV46ycO16c
IpAM4iJ8Bq+8tzL76dEeGYWBgrHUqasHNt+6I7cgqLxMLvLY405MYnGARblxW0uX
wyfxG0glLN+kFGIpIKRQARSz5+IKX6DgjWvwquhCH5ZOOe9OdkY4iyChwVsQ7tA4
VS4wU3jsSD9UgsMERT3K3X7f2fQ/ppwXhB08WWCSnTevzNhNvqAvEJnPc7HiKQmx
gkf3ONsfKcclCdECvH2jimm7/P6bLX3RbghSwRjQASR5Tno/JVCiFIXlcWYUV0FK
43EeK7sy6b98kPlWhW04cOO36Oxok3S9VrweHIN7S5F3kbUP7mkCKM++paPuKZcV
s/y9aQP0M6MwmwDdyuuzxljVRFcMoyglsYR0asjMn5Y3AeUYeI+aaftOxyKafMV9
GlbvsZWyo7UjcMp8O9G9X61XBJMAA/Vd2DEOmTi+a69tusgt7O2lMxtbEgWKdaZ9
iWss9tfGn/JGL0PQpmwrYPJa0D8VqoshNO9c8N70vXw0lFXvRKk/UGBOjRocyvlf
KXkYxfz/sRR7jnWKivy1+BrqGhwV7Gj091JqaTCc7Xt+sohDH3gUYRtA/Bm73PWd
9JryrFleanylANuCZYrXVnHIk5Hvd5EhZ7UMQdKdkzEiF5VkzG0w4Li36YEmTkNn
1Ly2kfBkGNg5B2dINeyx
=rgzU
-----END PGP SIGNATURE-----

--=-Wb0yGArfRonz/43Ol7Qg--

