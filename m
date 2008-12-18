Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbYLRRw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 12:52:56 -0500
Subject: Re: [PATCH v2 1/3] cfg80211: add PM hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	mabbaswireless@gmail.com
In-Reply-To: <20081218153042.GD4121@tuxdriver.com>
References: <1229313039-5544-2-git-send-email-me@bobcopeland.com>
	 <20081217153524.GA3539@tuxdriver.com> <1229537449.4268.10.camel@localhost>
	 <20081218153042.GD4121@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uCEz+nmm4qabessf7mb6"
Date: Thu, 18 Dec 2008 18:52:51 +0100
Message-Id: <1229622771.3601.26.camel@johannes.berg> (sfid-20081218_185313_340156_C9CA527F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uCEz+nmm4qabessf7mb6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 10:30 -0500, John W. Linville wrote:

> I'm not too familiar with the internals of the PM stuff.  Is there
> any guarantee that the cfg80211 suspend stuff will run before the
> bus-specific suspend stuff?  Is this a concern?

Yes, it is a concern, but yes, it is guaranteed that the suspend() runs
before the hw suspend, and resume() afterward the hw resume.

johannes

--=-uCEz+nmm4qabessf7mb6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSo3vAAoJEKVg1VMiehFYyQsQAIX4ZZYLc66/jXXB5hLa01Lx
5IhzrHx7IIREFBMM0lTReVPXPG/XZR8YWF8LuBnhjoGZUHOiyqiKwZaykbo6/HPn
shsMVerEII6URXpZWeJckrENBVPacIHtIWKDsHoogZR8VH6qdNSxR/VqavlEJ6N7
XBu8UQ4gxQ24ne9obujmh7o3S2GKPsi2YkKBIusjjm5gA6je996vDeR2Hcm1KzhV
OoKVEmZ6Gghy6nb0wbQcD0IffTl/m/A9gIcGXJlHWS6wIwgFiSdjHL14L5yr5nt0
JszRr55egQ/ss9RWagk3XHljNvegS5A9HHXeqFt63PsMWY/IjRjTRtIVRZEvkzwf
9Db7u8yUwL8Blu1JO70jbdCx/J49YjKIv2N11U87Yu+zdLX5EyssYXgf1mLvkBOF
E/ohiQ2J13VcS+g7qkTmiTmv13MGI5piyoysCs8UVXKUJgmVwo8j9ee38eROkQF8
haKmlXZWqc5ryiPtripVTT5ciLek/Ygny2qaQQCn05iX8ibDXmJR7B/VOF+47KtX
fhY2vWRsugie6npnxs1DaLhuaEKBoNhxhKrDnJo+NminMHNE9b8kggtYgaZ9hhGC
crqskXYm9kvtzMTPuO2zjDmHVTRds3KtA9avb/DT0Z6ia9zHI0/Nl5SW4E36lgal
4gw60fC9+io0BjU8zfxq
=/bso
-----END PGP SIGNATURE-----

--=-uCEz+nmm4qabessf7mb6--

