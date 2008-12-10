Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYLJP30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 10:29:26 -0500
Subject: Re: Listing established mesh connections
From: Johannes Berg <johannes@sipsolutions.net>
To: Keir <keirlawson@gmail.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
In-Reply-To: <e27b78a40812100713l588e5cfch952c3d909c1dea19@mail.gmail.com> (sfid-20081210_161349_313917_9BFFAA0F)
References: <e27b78a40812100713l588e5cfch952c3d909c1dea19@mail.gmail.com>
	 (sfid-20081210_161349_313917_9BFFAA0F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YZLqtaL7NbnWqymLIEfe"
Date: Wed, 10 Dec 2008 16:28:52 +0100
Message-Id: <1228922932.15837.4.camel@johannes.berg> (sfid-20081210_162929_388726_8E0A14D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YZLqtaL7NbnWqymLIEfe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 15:13 +0000, Keir wrote:
> Hi,
>=20
> I was wondering if there was an efficient way to get a list of
> established mesh connections for a given mesh network?  I'm working on
> a custom link metric (Packet pair) for the o11s stack and want to
> unicast a packet to each established connection.  I have been reading
> through the HWMP code, but it doesn't seem clear to me how this code
> gets a list of its neighbors.

I think "iw dev wlan0 station dump" will give you what you want?

johannes

--=-YZLqtaL7NbnWqymLIEfe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP+AxAAoJEKVg1VMiehFYM7MP/1b4l+l+5uopU5Gt6DtS/6zj
lTc0tpeZZOxup2mwfBJPAMlwtpGr/kDa2JIv37r4C4dZULEDMS9XvXvn4sBzf8wf
EwYCQ3waPZuy/xx7PX7SemSEjaRbVLz+iUSwI5P3iZIrrZq2+LaFgJPT08w7XfQD
/g0nxFRVyQ5HdDB5W6fzfMTh4ewtBJTw+YNcSY767NQ/RVLNVN+UvnC2i7liNL2U
oVSQVvSplzEPT6mUw331lUo4S+3mE3joj+OFHcllQjaDAeCDy0WojaXV7QtMR7TB
DDUCBaB6RgAZXqvT7P15p4u/xGoy/muf6PBvNtmySU01fwqnfW6onwzasbRDffWn
FMkDvGJM+E8nCFsl/VpUpxcVFjtLd8Q9Wnj5oxCBfiyVQAaIoyWmWpi29mSucEbp
/nqJ+HeMibS24SRDQhAwGe1GZ7o3TB49Gxl/26Lhgt0e2WzAUEzHFlGmp6cB1y/L
18lSjB3Gapwp0FWyFaBodDgVHwdoWgFOMapLXhb8/YBAPce5LmjAvPgECKK4WSU8
7CodNVnDfM0uElxdLDQGPxxjbIGhTtAEroC/JpgLYzbioJLLDBBfwldc5UiiUR0V
bGjSlDhfLfgyxUa73e3ZlywHi2PpF7n8Dgtzak9cuImQL0J6tdBHYERhwRVyrOw8
d31wkHb1pYDULCUPiJR0
=ZEkd
-----END PGP SIGNATURE-----

--=-YZLqtaL7NbnWqymLIEfe--

