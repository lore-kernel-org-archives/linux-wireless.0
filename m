Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYGNMkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:40:07 -0400
Subject: Re: [PATCH 1/2] mac80211: pass dtim_period to low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240807140538n671ac95cm3e4b1a9d25af411a@mail.gmail.com> (sfid-20080714_143858_122719_7A7725E1)
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038966.11189.12.camel@johannes.berg>
	 <1ba2fa240807140538n671ac95cm3e4b1a9d25af411a@mail.gmail.com>
	 (sfid-20080714_143858_122719_7A7725E1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j5eY6vpYwzycFdlgCyHS"
Date: Mon, 14 Jul 2008 14:40:02 +0200
Message-Id: <1216039202.11189.17.camel@johannes.berg> (sfid-20080714_144012_630713_C004FF68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j5eY6vpYwzycFdlgCyHS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-14 at 15:38 +0300, Tomas Winkler wrote:
> On Mon, Jul 14, 2008 at 3:36 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> --- a/include/net/mac80211.h
> >> +++ b/include/net/mac80211.h
> >> @@ -191,6 +191,7 @@ struct ieee80211_bss_conf {
> >>       /* erp related data */
> >>       bool use_cts_prot;
> >>       bool use_short_preamble;
> >> +     u8 dtim_period;
> >>       u16 beacon_int;
> >>       u16 assoc_capability;
> >>       u64 timestamp;
> >
> > Can you add documentation please, especially about the fact that it can
> > be zero if the network is buggy / IBSS.
>=20
> Right, I will also add fallback to 1 if it's 0

Good point, I guess that's the best guess then.

johannes

--=-j5eY6vpYwzycFdlgCyHS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIe0keAAoJEKVg1VMiehFYraAQAL9BobV7INFti7lDLl72DZPb
gMz1Rn1X0S3NYuxJ0s0eo7RxoNUwg5kQu/jNwbHrYka66KE9sd+Ae/3s0vfRjgSI
Xbx8deRoYxFCXue4Qoid3wNHGTh+wxyb1r+PikFqllwaD2lgwM5atkd8y/f1/dTj
Sn19XqmeqfaecQF//y2ck3w/YIMT0Sw5EusWRj9tJYjfZ8GqT+Lo6Wr+ItjWoG6e
O0Qb+oXgd4JVMyxD7jcpCQ6hxl/XjjMMHj6EFs0OLTKQ1TduUayAehASagifMDvO
Ir0pSsUoNRYDhp4B45bhNhPBzU8q0796unnkSVgODzUfrsX+WbSdHSi0kLqo4Q8b
yg5vTnFCde8+u07tPbUVZx/HlMZasbT040cqAIj2Gs9RtieWrUwmT7ZVJa7G7nFx
i+6TbIqhNXUJSRxx5wLA7pTc9CmFqVroDTVL64wNdF9fVMLkFDJg+XPWmzNXJZLc
JCwI+0E0flGrsh5pbIVx2bOK97GvFx/t/V9kk6uc21LoatCtxqQkS8W5MqM9wOGm
+AK5xOm41XQG8Vjdp6JtpmLUlEHnKhpWnzJ9wLeUJHtruwpzijx11fBb5Cm9lo4i
MdXHGAItSuutrJSwNr0Z9vfSHP5c8aWLl6swpj7JHSAgFYpUwyZIn5RGGxM2f8Ka
zMGf2m8NEMSGuS1WLUj3
=zPCE
-----END PGP SIGNATURE-----

--=-j5eY6vpYwzycFdlgCyHS--

