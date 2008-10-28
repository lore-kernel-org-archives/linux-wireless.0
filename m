Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYJ1IH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:07:27 -0400
Subject: Re: [PATCH/RFC] mac80211: convert to %pM away from print_mac
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20081027.155243.206513005.davem@davemloft.net>
References: <1224892243.3919.32.camel@johannes.berg>
	 <20081027.155243.206513005.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QoJ9IJudhfVfx29+Vxap"
Date: Tue, 28 Oct 2008 09:07:24 +0100
Message-Id: <1225181244.3796.73.camel@johannes.berg> (sfid-20081028_090731_692403_17A5255A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QoJ9IJudhfVfx29+Vxap
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 15:52 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sat, 25 Oct 2008 01:50:43 +0200
>=20
> > Also remove a few stray DECLARE_MAC_BUF that were no longer
> > used at all.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Not sure this will apply to your tree, I prepared it against John's tre=
e
> > which might have more things. If you put the previous patch in, I
> > suppose John _could_ put it into his tree, but then he'd have to pull i=
n
> > yours which he normally doesn't... No idea. I can also just postpone
> > this?
>=20
> I munged this to apply to my tree, the only conflicts were in
> mlme.c

Yeah, that's the ones I had too.

> Sorry John, one of us had to deal with this :-)

John, you can always just take your version, and if I see print_mac show
up in mac80211 again then I'll send you another patch.

johannes

--=-QoJ9IJudhfVfx29+Vxap
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBsg4AAoJEKVg1VMiehFYV+AQAIWphczN2nyxf+kCCFVp/F6D
ZrQMxHslMdkXUs22p15k5GyopaUDv2+2bUcnUZ/8mbjZxJy30+dmyJaYk8CunVPJ
AWCPcyDGmujA2y5XkOxvViXeAEChVHuJsOwsvtKX6mni4UWsNVRjF1OeQGmft/fP
fa84a0O1Iwb2UBvg5FJHEv/Nnym77JmkyZC3uMZD17bffkSgtNhRgQvhYkkcK+Fq
E6Mu3QEd2Cw9eDXul4QemzIwFw6MaxiwoaqJsVv2AIbnzgTMaN6ee3gnYELKQT8f
gK/GCRlLatC461QyMcknyZwY7mncwrI6A8hY2u0yNXwu/FOEINBTq5EOHPNBPNm9
eHbOG4Oh8zNaE0OiH4Lv6N7lNSCvlwkm0755fvzPJEIfF8LcMDHzJbVjLvACe9bT
dlpq3bvwdYeXP1/DYZiVN+zNQHK20zBq+JG1HMoa+/Fr04e8CFT2bwbe/kjwN2rg
O+yu4T9vn+DCSAdYIiInI2TN902X+OBMWsVNr752xyPCAs1kLs7+PvoLmjh4q4cI
rfmGdAdROv9QWkPh1uiFAI6wyb6JyYMbDykCk4kQjRjpWZbzZyBFpxlAxaZKK6tB
n4txkW4ZRH8KR2hp2CvQq526atyUvmr9GDxluLsIjNvjIY0yRzDl8AHek9n5p+wR
N15tFQyt725bW2g7rHnq
=KY62
-----END PGP SIGNATURE-----

--=-QoJ9IJudhfVfx29+Vxap--

