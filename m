Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZBTQ5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 11:57:31 -0500
Subject: Re: [PATCH v4 00/15] cfg80211: add a workqueue for regulatory
	processing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902191640u107ff0fdse92367fccc975dba@mail.gmail.com> (sfid-20090220_014115_061983_954B3E1A)
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
	 <1235050171.4023.64.camel@johannes.local>
	 <43e72e890902191640u107ff0fdse92367fccc975dba@mail.gmail.com>
	 (sfid-20090220_014115_061983_954B3E1A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ds3y/xIPbsSxaJh+xP7X"
Date: Fri, 20 Feb 2009 17:57:23 +0100
Message-Id: <1235149043.4023.66.camel@johannes.local> (sfid-20090220_175739_970074_71A77760)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ds3y/xIPbsSxaJh+xP7X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-19 at 16:40 -0800, Luis R. Rodriguez wrote:

> > I don't know why you insist on having a wrapper for
> > wiphy->wiphy_idx but it's ok :)
>=20
> Heh its just because wiphy->wiphy_idx does not exist, the drv has so
> you must go to the container and then use that. If we move the idx to
> the wiphy then I'm good to use wiphy->wiphy_idx. Want to do that?

Ah. Not sure, but I don't think we need to expose that to drivers.

johannes

--=-Ds3y/xIPbsSxaJh+xP7X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnuDwAAoJEKVg1VMiehFYKtAP/irX8eMU7Lc3zFse7vTz7VAZ
4yCryBPScFMDZVnTZJ/9+hownNEr5YTf4nlLCC61o7JnpKagUxH0sojfIvhB8vtO
2TsHspidB+l9ybIAq81pgd1mAPtXHJf5OPMG13d5Pn73jbzvQh6wbJ3LiHemq/hg
+9C9EecGvSXwp41/xcN82eqFq97tlfhV+gYpiFW/hq9ceMfjjjvYZtTojo0BfQPl
5qvCThuQX/sj+pMKjNCJI1BYgrsJxrsqu//uppstUUn7dJ+S5iITK17g9XGjvFpP
jFO1HsDUc3wuQqiWuc0KTBeD0LhqIfxFC0NyfC394zwaEThM0iv6R3j1zt0yasBw
PjOdsdw9GAlHiWjZy8lCrUY8BTh63WGI4AZT5AXQz4SLOrKtOMhS7ra/KImZJnAp
rJFUhqKtCbV+U34jePNPFC7dE1EMzzMzp+RqQ/VpwiV4Cg4xmzgAwayv3KVuXOyq
Z2MYSPrvsEMcnh0oqfNsTj/0dyOHXg4+5f07ux1q9Q5klh7zSUXouvWUfA/8zQ3F
LKrHhVdcGei6wbqZ0wSlyTC8+C+BMoRjL+2236wpn4AmzJtxIfAZL1n+wL6qK8S9
i3AJDRj6w43eSBQ0JdOWSHvWWXQwCnWOzxm8yJQ5eJ6sRg54YffMeAividwghU11
ZVBkdYrV7LhV+IsULg4M
=XX6P
-----END PGP SIGNATURE-----

--=-Ds3y/xIPbsSxaJh+xP7X--

