Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYFPUrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 16:47:06 -0400
Subject: Re: [PATCH] mac80211: remove shared key todo
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213648729.18384.11.camel@localhost.localdomain>
References: <1213642529.3803.47.camel@johannes.berg>
	 <1213647566.18384.6.camel@localhost.localdomain>
	 <1213647709.3803.50.camel@johannes.berg>
	 <1213648729.18384.11.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-daCnBkfDuXGIpD8KzaJP"
Date: Mon, 16 Jun 2008 22:46:16 +0200
Message-Id: <1213649176.3803.55.camel@johannes.berg> (sfid-20080616_224712_427347_D7BD144F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-daCnBkfDuXGIpD8KzaJP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I have no idea. Usually, you don't even do open auth for IBSS, there's
> > just no point. Unless you get into IBSS with encryption, but we don't
> > really support that yet, and we probably never will actually support
> > that without the userspace MLME in wpa supplicant.
>=20
> IBSS + WEP works at least for ipw2200 and other non-mac80211 cards; I
> can check it out with mac80211 if you like.

Yeah, no, +WEP should work. I haven't specifically tested it but I see
no reason for it not to work.

> Any particular reason IBSS would require a userspace MLME?  There
> shouldn't be any rekeying of any kind with adhoc, since there's no
> central station to coordinate the rekying.  AFAIK with IBSS you just use
> the given PSK at creation time, and never change it.  That shouldn't be
> too hard to handle, right?

Well, I was really thinking of RSN/WPA, and last I checked
wpa_supplicant didn't even support that with IBSS, and I think it
requires userspace MLME because you have to do the auth/assoc sequence
with each peer etc.

johannes

--=-daCnBkfDuXGIpD8KzaJP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVtEVAAoJEKVg1VMiehFYrvcP/jXfUPUlaqEeYdjTM9g9KMJH
SDHckkfKnxqIfMWhhi8A2Wuu2IW95RCTeG3IkW4l0PRcQYCd7kz/jQMjUZgAqZBx
M6mJrEDtdUN7Um0nEM3VgYlP6wguytCGVBUVJDxrpMRbQt+lRriDBGXrHxm/QpUj
GJJ5ykS1nhbICxWexLUmcinni7wJ35pbrZnw5LGb2pOh4fwm+uuH0b9zE/eoDpBB
OJTi8IPLAM052seunFegMIVwlZwJFyFbbqd/HEWx3cGWS0avjrOZu4T+iENKhIJo
Ty6FhHn5L7eValphXhbWevi3UBUuhdrTvR9qYjj96Rr9piAg5fOqOcrJz0Plug/+
1iumLju3QCv7HdGnMskM6Yv54mTd4hiaITh72X3/UOq65DxXZTGfw0E4aj+kI+Ml
KLXpwBs5mg2PHzaqY0BnnraNNwBjRX5MyitryJWI36U7vFckz9c7QZw64IGuFGOo
qDYxVwdqJwKIedxbPmHvOmB3iNgGGkkhW6YD4zuQHtjM4MmAeyHmS+UVIrEE5KJ5
+60HFLjBNqHHHCjSuuGG90n7pg/f40eLxZ1mngN/RjWkkkqTzh3cZFQh8v/E11Xl
QqdIKDUaj2WPCaITwyS72L+V9VeaTLpS+fahnG/ubbA9no4G8q72PJ7Hlq6bMsZJ
DttZQboXCc24p1E3xbPK
=Fsx0
-----END PGP SIGNATURE-----

--=-daCnBkfDuXGIpD8KzaJP--

