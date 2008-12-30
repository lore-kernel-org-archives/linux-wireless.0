Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYL3Wjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 17:39:43 -0500
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	berlin@berlin.freifunk.net
In-Reply-To: <20081230223611.163110@gmx.net> (sfid-20081230_233642_601178_E4AB42EE)
References: <20081230025651.6500@gmx.net>
	 (sfid-20081230_035657_768921_742B8565) <1230633565.3850.7.camel@johannes>
	 <20081230223611.163110@gmx.net> (sfid-20081230_233642_601178_E4AB42EE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LARFSvx3Uj/NlXeEn2Jt"
Date: Tue, 30 Dec 2008 23:40:11 +0100
Message-Id: <1230676811.3850.22.camel@johannes> (sfid-20081230_233948_041685_97671A2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LARFSvx3Uj/NlXeEn2Jt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Alina,

> > please use a bool for that
>=20
> Yes, but the called function is written in the old C style before C99, so=
 I think I should use the same type.

I disagree, even if the function doesn't use the proper types
pervasively, we shouldn't be adding old-style stuff.

What Jouni pointed out still stands, you should separate the bugfix and
the 'disregard ibss join' feature into two patches.

johannes

--=-LARFSvx3Uj/NlXeEn2Jt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWqNJAAoJEKVg1VMiehFYJlUQALKUjNo32k7Sm/1MR9r43NVV
osdGSV7JXnqhpDwTyReJteL3YyBugwlGPBaZoNoHQUCtzA+XmP4JDvfMfFyWw2+u
vCONGf0jzEKEzVi/mXImQHcfk5QLVvVlmas5b9wsleYiVs2N9TqN0LG/GZpEfXpp
qZmJ62EJjOkK8nZy0Ou2BYK1IWkkNCZtkizw6BjFvVOtQNmpTABHm58dhIU3yeWx
lqNi+YFUJfGFdG8bBAYloCvFMIHBhYVpounie17d1IWmbld295EcOywYHY7y6FHQ
vnK2TQdEPtp1FMq5UE2TKavIhX2ma/WfB1hshMvuMqsAHXw4q9khlEGfx0FnqBva
zBWgRkDG6yAntBZfL7ZGyf2PyAIxoT88z+fopNKjRxFxxVZzdzIiqw0MDEJzS+z1
vYfLFTSx2mmmxWzH9gCtsJlZcRy1eCbGXolI4xU8/9oM/sOXqwGWJjJRWxetuQD6
GwgGI03ukON2jO5duN9npngYJpoWqS9eT4n+2t44/2U1fhiUN+CrGgJYIwK2twZE
kAs8LT7g8OfPKoK4HUIrT0VlloMAgghkLcJ0DN3hVXvUHxLpgjvdXheVaxLJThK6
qhqSnLyY+mT1/QbGBl8UR8pQOhWVyqepA1IXtq7hfzLemluLNZEYcEJ0R4izoogE
4ZV6E+vAeX7rBJXuoSb6
=Xa6+
-----END PGP SIGNATURE-----

--=-LARFSvx3Uj/NlXeEn2Jt--

