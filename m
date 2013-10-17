Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:8647 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3JQO6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:58:16 -0400
Date: Thu, 17 Oct 2013 16:57:44 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH 2/2] mac80211: store the channel in wdev upon ibss_join
Message-ID: <20131017145744.GI2596@neomailbox.net> (sfid-20131017_165819_378953_07890120)
References: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
 <1381790282-1146-2-git-send-email-antonio@meshcoding.com>
 <1382020588.14410.12.camel@jlt4.sipsolutions.net>
 <20131017144824.GH2596@neomailbox.net>
 <1382021488.14410.17.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dDnEQgWzhgf+8aPe"
In-Reply-To: <1382021488.14410.17.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dDnEQgWzhgf+8aPe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2013 at 04:51:28PM +0200, Johannes Berg wrote:
> On Thu, 2013-10-17 at 16:48 +0200, Antonio Quartulli wrote:
> > On Thu, Oct 17, 2013 at 04:36:28PM +0200, Johannes Berg wrote:
> > > On Tue, 2013-10-15 at 00:38 +0200, Antonio Quartulli wrote:
> > > > From: Antonio Quartulli <antonio@open-mesh.com>
> > > >=20
> > > > To allow cfg80211 to use the real channel to pick up the
> > > > proper (i)bss object, store the used channel in
> > > > wdev->channel during ibss_join
> > >=20
> > > WTF? No, mac80211 can't just randomly modify cfg80211-owned data.
> >=20
> > Mh, ok. :)
> >=20
> > What about setting wdev->channel in __cfg80211_join_ibss() right after =
having
> > set wdev->ssid ?
> > This way we leave mac80211 out and we totally handle this thing in cfg8=
0211
> > only.
>=20
> Locking might be problematic though. I also don't know where else the
> channel might be used?


I don't think it is used elsewhere in IBSS mode


--=20
Antonio Quartulli

--dDnEQgWzhgf+8aPe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSX/roAAoJEADl0hg6qKeObowP/ivCnOkyjDlaiMK7zDeIwnxK
l00KskKpiJfPIJb3zD6XEu0nefR7I+A1LPGWcWv8XURfpY1jvUTZ2cknSiNUp+QJ
01VZw9+xzaUNqPJrUNd+IPhsZrKCSYrChUqQQIuQ/1/I9WYjLbgBDpHY0pyhIcAi
5HpBJf3NmYq3bIRQKJUyJY91yox2cvn2S3rGdZWNni9k5GEGnS+C6AhXnSTdiMp6
YDWSFzJHDpw1gQQgljKdjAgJ8/MT9xTuoTXEmMEnjfHmZLsHqfq+e5C4tJBp1gZR
MgYj4CGMDg/vpWXMyivkYG8p+9VD3t2VhyRolZsqmTHmRoJ7u9R6k/5lqg7XPAiw
Q+D6KWLT1yCpidyC2hme9wYwgCJ3HqjMPwj0WFzrg74vxX02fjW54/k4c80ThdBs
TBJhXUMJgzjbTk98rv8whj9WRico7WFlT2JpJJ77gm3jtkB0Fqs483cR8IXjBMWS
BwlW0gJtMBBXB3T5thXuSvSQHUKsfom0MN7CaUvtgHuJYdwyeScOyoSWC671TFT3
5u8xipcpteFkogWK0hn6L2RYDZzAQLQSS6DXQZQHxT2yGiVQ7bnVklLe0QxxgVVx
c8KHtVo49YdHYBn+xhRGrZ/p7WWBEz9B8r5CqmrL61sSf9tjKDRqP6J68SDHufB3
5otintcVGNRztcnFoQtU
=7ANS
-----END PGP SIGNATURE-----

--dDnEQgWzhgf+8aPe--
