Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:56811 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaESPun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 11:50:43 -0400
Message-ID: <537A2807.1070703@open-mesh.com> (sfid-20140519_175046_560832_63598E89)
Date: Mon, 19 May 2014 17:49:27 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: b.a.t.m.a.n@lists.open-mesh.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 2/4] cfg80211: export expected throughput via nl80211
 (GET_STATION)
References: <1400344906-27984-1-git-send-email-antonio@meshcoding.com>	 <1400344906-27984-3-git-send-email-antonio@meshcoding.com> <1400511606.4273.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1400511606.4273.18.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aibALLuC0tBpqiFt2xUW3mCswQSkFGEaN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aibALLuC0tBpqiFt2xUW3mCswQSkFGEaN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 19/05/14 17:00, Johannes Berg wrote:
> On Sat, 2014-05-17 at 18:41 +0200, Antonio Quartulli wrote:
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> Send the expected throughput when replying to a GET_STATION
>> command via nl80211.
>=20
> Since both are pretty short I think you might also just squash patches =
1
> and 2.

Ok, will resend with 1/4 and 2/4 squashed and I'll add the u32 spec.

Thanks!

--=20
Antonio Quartulli


--aibALLuC0tBpqiFt2xUW3mCswQSkFGEaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTeigLAAoJEJgn97Bh2u9et6sP/iShzFNxV4ihghNbM1oRzSBd
5LrDmBipF3UySNq/Be3fIkpilP40LxkUXSzGRnrPPZTObB7ZwtpgtxUT5XzEXxfB
XTW4PViotjDBS+iIpAhadbphoGpuN6eZVKeYERWLHWu+NP9pJcYlKhekVNB86H6c
a+ySW1lBnNsSrbvxaEn5H+gOqkb6tFy96K2rHgbOSnZmI0jRmv6Cg8+3wTD1eSvZ
sHyJ/KYsGTEd3xKU7F5f1doZKQ2zt15ThRMEXEW3tMSeZua5Bpk3u1jQpbep7ctU
r1usOOBlu/zzo0PueMWjWHrjHYVU5CFNrvw96fbTkWiDyt0m7sD49D9NqX3Vs3Eg
BEiD2zgG6vqlh85BPdHYADVlx3pw2nVhZu4A3lN9HeLLoXDL9Uehaq2ZIyVrv4aE
pDGLZ6Bq4GFrKjAVidRaoW9CzhZ/hLNX2lvUO1ZeoaavBnuWqzZXEKrr99yAZoCu
ONJjvThUUQ9elhMOfhImypUgda4jMFS3g6z0bWFaTOtBzve2clPFqtgQ1HZ7YeMa
/TubQYThj7sAbUj1WuWw8PbIaUPMi6Q0WwrZSYa2OdR8HBTo/GLkHk9giINqNA+f
vjxHIoU4sQIc8lcQ/VB7+I+UIoQOzPkuj2wtMEIdBowGEJyK+2Z5IJ4VOGJgJBwk
YNXfAQi9/J84WOcWGwqy
=O5O7
-----END PGP SIGNATURE-----

--aibALLuC0tBpqiFt2xUW3mCswQSkFGEaN--
