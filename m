Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYLLWjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:39:01 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4942E7A4.3050206@erley.org>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>
	 <1228780960.22164.162.camel@johannes.berg>  <4941EF69.5040108@erley.org>
	 <1229099080.14423.15.camel@dv> <1229119118.3572.6.camel@johannes.berg>
	 <4942E7A4.3050206@erley.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+TTqP5C1ajdTVZiFrapu"
Date: Fri, 12 Dec 2008 23:38:55 +0100
Message-Id: <1229121535.3565.4.camel@johannes.berg> (sfid-20081212_233906_069718_4A6D3DAB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+TTqP5C1ajdTVZiFrapu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 17:37 -0500, pat-lkml wrote:
> Johannes Berg wrote:
> > Thanks for the review, Pavel.
> >=20
> > I agree with all you've said, Pat, care to make a new patch?
> >=20
> > johannes
>=20
> Pavel reviewed a newer version for me while I was at work today.  I
> didn't post it to the list as I didn't have access to this account.  I'm
> going to implement the new set of changes and try to submit a new patch
> some time tonight.  One question, is it preferred to make the code use
> the new API and add compatibility to make it use the old API, or vice
> versa?  I've written a function that uses the new
> genl_ctrl_alloc_cache(arg1, &arg2) syntax wrapped in the old arg2 =3D
> genl_ctrl_alloc_cache(arg1) syntax already, but based on Pavel's
> suggestions, it seems it's preferred to go the other way?

I think I'd prefer using the new version as well, even though then you
have to make up a bogus return value, but it seems easier just so we can
at some point just remove the compat code for the old version. Maybe.

johannes

--=-+TTqP5C1ajdTVZiFrapu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQuf7AAoJEKVg1VMiehFYvRYP/isG6DFf9WCMyXAAlXQ/20g/
K4B/HauHEvn8iM3Yqwz+S1i+vh64TduNjz7/S6i0FON3DBcTu5PIvH3A0ol5dV8e
vOcmXajbjX5sivvo4uRIF7SWHWZoDkEj4jqMjl6egUpBWy/pbKct6YG96lG8e7A0
z6x6y/nJG3/sGIRnCfFLVHYAsHhzMGR2lWTdXnf86ltvDInNgSLo54Yq4ciQBh92
ZHOg9dy9D0fJ9FqLzH2DHDw9Obxs1jJ8EbhJdioHNlhuP/NJ9FuOfE6BWwuik/ou
bXymWamwOftwl2G0jdBpeHybsFgJ2oZV1mAioq86TKA8B+7GPREYy8gbr5kpudDn
/r0DXp2tS+JOPtP076MIyvO7qjgLfoxiWUwG6BDEw5+5sPHlEHFpkdaqqOglyFe5
Yvf0xgOw/BgvwIA4Ny60fnHO5/3QQgQC2IotfO1BRe5x5Kg70ppVwWmzoZ6Sku56
D/aqa1jc6oOAbWIIPbC5CNmu9DSLLkqZS6sybTAZiT312Wy5f+0FgCxwEX2PkhV0
EWdlM5W7oJY6sAJLcOh+pdihRjtwnVRUb+gyjud6ldt5z1wp4W13DNZm8WmMMpsi
l1/P9kTQ/dFdAmmoKfoICAgY2s2IFHJLLu+n98hfsaxpKRwFTwr3wkuRZLGONAFu
zGCBJqn3FmjtEIwHpqJW
=WHPP
-----END PGP SIGNATURE-----

--=-+TTqP5C1ajdTVZiFrapu--

