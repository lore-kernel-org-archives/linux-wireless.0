Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949AbYEMJB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 05:01:26 -0400
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080512.205224.12536510.davem@davemloft.net> (sfid-20080513_055232_974929_109C289A)
References: <1209936253.7304.10.camel@johannes.berg>
	 <1209936745.7304.16.camel@johannes.berg>
	 <20080512.205224.12536510.davem@davemloft.net>
	 (sfid-20080513_055232_974929_109C289A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ew1AFiFft0VbkSEgQLgw"
Date: Tue, 13 May 2008 11:01:13 +0200
Message-Id: <1210669273.3646.51.camel@johannes.berg> (sfid-20080513_110156_559893_B809C5D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ew1AFiFft0VbkSEgQLgw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-12 at 20:52 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sun, 04 May 2008 23:32:25 +0200
>=20
> > This assigns the netdev's needed_headroom/tailroom members
> > to take advantage of pre-allocated space for 802.11 headers.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Now that I've applied the prerequisite patch, I've added this one
> too and will do a lot of build testing just to make sure there
> aren't any surprises.

Thanks! Will you put in something like the patch that made dev_alloc_skb
reserve more with the bridging headroom as well, or do you want (me) to
look at routing first?

johannes

--=-Ew1AFiFft0VbkSEgQLgw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClY2KVg1VMiehFYAQKiwA/7B4aI5dl+l3W+9W7eGjNMzKZYGErVcALI
BaxFT2pJc8D5ZmOyulub1zimS3q00FYyBF16BRiF8UMw6o8kql2UmF7QBaHfxBNY
QypLpW3UtDUJmlQ3g8qK0YXvSmx8lzdvcWyouZvtXDzyXc0l+u59yzw1SZ1aUnPA
9jHfZHU7RQzKyyE03N5CuKxUWwXi1OKjj+iBhaMLcbGre4fvie7Uidx+VAZcoWd1
RaYgmxV8uq6X6cJHXA03NMD8v0w3r2lfWVa8D2kOYaZTyeJDNGhxkS9Uo2LEcAzC
CkPlYUSJki3AKdcEDwu/BuT43rYLUVIVo2TALeMz5Tt0+B1aNcftl1GGnJ4fOL9B
sHmfjhSx7+DxLTcC1MqwEIjpUnPP9tWrNd0PTmZB04uaC2T4zamYmrzPYDSNVLUp
POCbJ50s1Z1mbybZOO0B/G0PAul8m0mbl8d3MPfDpg8fzh/OO5Y4w+SZDF3fQ+ea
z39XiuCOeUfL+eaHAV0+yxdH9XphPzz5jimm7eS53pea0RM8hY4Mxd+hGlyH9vZM
ore3CjkKcJE0ekNOk5fOi1e0DDCjbdAqJDm9GyLbCylA7WGOJ656x/GuFK79qLZ7
pGFZakS5uSOoB6zrBsqDOmDRuihEBsEWLWgxpozQFp6W0PQb+ZTvqG1I1tObjvPH
8qEYH0adE94=
=PtEJ
-----END PGP SIGNATURE-----

--=-Ew1AFiFft0VbkSEgQLgw--

