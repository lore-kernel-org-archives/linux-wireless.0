Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYLIMPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 07:15:24 -0500
Subject: Re: [PATCH] mac80211/cfg80211: check endianness in sparse runs
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <20081209121231.GA3578@uranus.ravnborg.org>
References: <1228822793.22164.210.camel@johannes.berg>
	 <20081209121231.GA3578@uranus.ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v0tbRODOS4dz8JgSognl"
Date: Tue, 09 Dec 2008 13:14:46 +0100
Message-Id: <1228824886.22164.219.camel@johannes.berg> (sfid-20081209_131532_843010_89858C44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v0tbRODOS4dz8JgSognl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 13:12 +0100, Sam Ravnborg wrote:
> On Tue, Dec 09, 2008 at 12:39:52PM +0100, Johannes Berg wrote:
> > Make sure sparse checks endianness when run on mac80211/cfg80211.
> >=20
>=20
> How far are we from being able to do this kernel wide?
> Some effort has been put into lower the noise level I think.

Not sure, I think Harvey has been working on this, Harvey?

johannes

--=-v0tbRODOS4dz8JgSognl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPmEvAAoJEKVg1VMiehFYB5sP/0L4X2Z+54j0AWZRifwh2HAC
McJWcaSJbra/AXIQMLaIrPqvnvmJ+ZK7mPJDIXdv34OLW1+6+rXxHgg5BHkx6pBD
lRPfgGFRXITrJ3SshODqhide2MZgFBVCmcUTqQ0xRImAmvgMydZEI7WjBjkCmEFZ
voW8LMG2khnBPDu6hrNJfKHeuzWFBNGpp+JoJUc+GWlbYBBV/oTE3N3YldZX5BVH
zs7dtesliDVFe0FQqt9xobAADKju+bsqa1PGot70WPwsydXasvnEgbCmp3OOHD1i
vubREXxGIOWAf6rJZu5qROjL2JDx5HvqWpH8POYnajgDj3BkoGw6qUcskgun9Vib
o2sRH2OrtX1buk/m7HyN4eqxCHf6Zhlg+2OEu5mABmjWkQONmsoewDxtEAw4tYzD
DSiB6nh89SNCHu/NJp88K7yCVqnGYVqJ3NPgHjckjlzGqFNaGWtkL1Tb3C3WP6Fu
29/JRBalLHPfcCdmgfBLK6gsLA2ao7L+8Gy0e1osCi8KTLVQhcqaW8XDd8vO+quX
cqaj/pl8axaIx0mB2vHNPF621JGVntWskl/AW9HG00cf26kC7Wkh+mGZ9W3j+lBC
XrFVfTjRIh7VaRHOE1qUquwIYxkZRqFJIXmF+RydPsR65qNo5ZyoVA1ucdYE1bww
s4AYGIhgKW8dIiSTcr4b
=/Z21
-----END PGP SIGNATURE-----

--=-v0tbRODOS4dz8JgSognl--

