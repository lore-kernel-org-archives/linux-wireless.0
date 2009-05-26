Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZEZWgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 18:36:39 -0400
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
In-Reply-To: <69e28c910905261227o7bbf81c8jbc5014792acb3af8@mail.gmail.com>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	 <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	 <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
	 <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com>
	 <3ace41890904070049tc2ed1baod4399a327505ef09@mail.gmail.com>
	 <20090407160812.GA5758@tesla>
	 <3ace41890905250008q255d15dej45a4f53d9f8c90e4@mail.gmail.com>
	 <20090526163013.GA7072@tesla>
	 <69e28c910905261227o7bbf81c8jbc5014792acb3af8@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OAETc9Yhv6ujy3SOVx1c"
Date: Wed, 27 May 2009 00:36:35 +0200
Message-Id: <1243377395.23825.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OAETc9Yhv6ujy3SOVx1c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-26 at 21:27 +0200, G=C3=A1bor Stefanik wrote:

> AFAIK the developers will never accept any AP mode for zd1211 devices,
> as it has no multicast buffering feature in the hardware. (The vendor
> driver, as well as the Windows driver implements AP mode with a spec
> violation to get around the lack of a multicast buffer.)
> CCing Johannes, he was the one who initially said that.

Pretty much exactly it.

johannes

--=-OAETc9Yhv6ujy3SOVx1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKHG7vAAoJEODzc/N7+QmalVoP/0zclwwigTYsNQKPoSLZiOep
vwhKVT5qhpxTN+giLqZ2OkRGZq44lf2Xj2oDnIwzx7Zd3PCwby19uYkSpOMKEIvG
eLKW3kQIg3YlC7cVoSL/9DNBMUz9mlULD2yKpEZVtt4vmDEaU6PGNLjbgecwM3Zw
J7AnauYyaNUp1/kKDojebJitWavnDER2AUd8gN9uSLkVRiq6OIp5ozU3btg6vrf2
UQoRLMhcSJS+dRk8TgouKR7liTFh4beeM5E8T6gQxwqBDUoOqBPOZ9zz8+khvA/Q
hJSscFKHgMKU0VKLYv/IHhpH8o6ghoSVc9ahr0pk2b12g5aEtBVUqJILpEKRHmPB
RYSMnYceWeHMZDk6Axm+UoUWXTcdg9xwa0SPMruVRAXlfmdUvNfithjy1wWbivL0
w9emJuNqrNkj7cM1PvBUvQjn0jlFvIkt0Dw6VUzd1UD6IbawSjoVn1YpS8MT5kxC
pA5liEskxq7OV6l1TwtL5wUtN6OjAc39I4YGKQeZI72qlLhnP+iqkK2f+GMcSSRJ
A/wCkoBK9HOtAWuvEajUkq+9eIiUrIjXYskrQjYyQjN8YNUIhbHEr0rckZY0XCLi
vcbNUsIShiEjJOxSoEYkSjnHhJsf5yoX3NS+6q2r7RrmLuESKLD3JtA2zSoB4Yze
pDhkFdwhzA5eybgrs+qL
=24CK
-----END PGP SIGNATURE-----

--=-OAETc9Yhv6ujy3SOVx1c--

