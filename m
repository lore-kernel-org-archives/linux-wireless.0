Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863AbZEDSEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:04:14 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241459295.2903.40.camel@localhost.localdomain>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
	 <1241456088.8683.62.camel@johannes.local>
	 <1241456863.2903.29.camel@localhost.localdomain>
	 <1241458558.8683.84.camel@johannes.local>
	 <1241459295.2903.40.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-krMizoYlHiVe8JiOt8Q5"
Date: Mon, 04 May 2009 20:03:44 +0200
Message-Id: <1241460224.8683.87.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-krMizoYlHiVe8JiOt8Q5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 10:48 -0700, Marcel Holtmann wrote:

> > Both are HT.
>=20
> do we have the specs somewhere then I might can give it a try. Also WMM
> needs some improvements.

The IEs are defined in structs in include/linux/ieee80211.h.

> > > The other one that keeps showing up in my area is:
> > >=20
> > > 	Unknown IE (47): 06
> >=20
> > "Broadcom proprietary" -- seems it would make sense to ignore that.
>=20
> Since it not showing up until you give -u there is no need to ignore it,
> but where do you find that this is Broadcom proprietary and why the f*
> they get to use an official IE number?

Check the link I gave you - lots of companies have IEs rather than
vendor IEs, predates the vendor IE I guess.

> > > And I do have some other vendor specific ones, that I don't really ca=
re
> > > about and we might even never know what they are:
> > >=20
> > > 	Vendor specific: OUI 00:03:7f, data: 01 01 00 17 00 00
> > > 	Vendor specific: OUI 00:03:7f, data: 02 01 01 4d 00 03 a4 00 00
> > > 	Vendor specific: OUI 00:03:2f, data: 01 00 01
> >=20
> > You can check wireshark, sometimes it has something useful. I think
> > there are pre-wifi HT IEs too in some vendor IE, might be one of these.
> >=20
> > https://mentor.ieee.org/802.11/documents?x_dcn=3D31&x_year=3D2009 is us=
eful
> > too (at least for 2009, for next year somebody will have to find the DC=
N
> > again)
>=20
> I found an indication of what bit 1 of extended capabilities means. I do
> have seen an AP with that somewhere around :)

Actually extended capabilities aren't bits but values, I think? But
that's something about HT too, iirc.

johannes

--=-krMizoYlHiVe8JiOt8Q5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/y39AAoJEKVg1VMiehFY/nQP/0qD9df2CwlgIBloXy14Yh9D
j9WK7nVZBwQnwe5zYdXPjZpOHLd7hdrBv2iJqMtZzH+EVZCXv97aYMroC+EOyPlw
oLYavLiuh3oqMme3m75xjQQZ+6LPzTNoVKYqlIWhztSLTwpU0NyAOjZoSjBtCMlB
JUn8IsPH30KVI/3ElFVP66IHrTM3sv1THe36pXk3u/NSghAKU8Ar2Z9Qxm/aQ+Ov
8iE6Q22wANL6jQ8PAOokEjUTERLswzZLKQ+k+zl+vUrrpujzdXinaW1mn23rf3h2
Uw+rOQCk45xjcpi1AufpkR4PM669qtz4PiEcOBf1QPzKrmoBAeWzXibem9nfu+hS
cjc1wzsSMowR9/W1U/4FnMgo1Vs9ZsslXu6YmFwLMsfOVhdW+yk6h7xHb+0ayzQk
pWLAvygpNV/y0zwp/sbece6J0bNjpB75WLL0rX33zVQp5NHXkvGMpoPs6MhLWFgI
KS7XXlqkiQA63L7n7w1bGy6XgjBRLVnVi43D0jt8hSWH/U822FqXY7ABQ77sW0+Q
M/i5GIttte3jd7nCYMVuCm1ao/KGXcO0fQCt+GFVIk6B3sWMAlpAALqiOjJQp5U2
P5ZViLUnUnoqJbAdZNFjPQVoA8kSXT3jj8N3jdsGmSRz10t4weqFPpr/fdT9so/G
+vQcNhIC8SnVRZsBq9K3
=A75b
-----END PGP SIGNATURE-----

--=-krMizoYlHiVe8JiOt8Q5--

