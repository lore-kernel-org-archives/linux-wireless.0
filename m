Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbZARItS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 03:49:18 -0500
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090117220636.GO29609@tesla>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232097659.3854.20.camel@johannes> <20090116163646.GG29609@tesla>
	 <43e72e890901161413n3fdd7031lfdd0a363941b697d@mail.gmail.com>
	 <1232184649.3668.2.camel@johannes>  <20090117220636.GO29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TV1TRfCNK2B/wVRTCekk"
Date: Sun, 18 Jan 2009 09:49:17 +0100
Message-Id: <1232268557.3877.12.camel@johannes> (sfid-20090118_094921_028539_18377D77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TV1TRfCNK2B/wVRTCekk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-17 at 14:06 -0800, Luis R. Rodriguez wrote:

> > > >> > +static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, =
u32 *bandwidth,
> > > >> > +                    const struct ieee80211_reg_rule **reg_rule)
> > > >> > +{
> > > >> > +   return freq_reg_info_regd(wiphy, center_freq,
> > > >> > +           bandwidth, reg_rule, NULL);
> > > >> > +}
> > > >>
> > > >> Are you not using this or am I just not seeing the user?
> > > >
> > > > Yeah -- good catch, its just cruft left over from my previous work.
> > >=20
> > > Actually  freq_reg_info_regd() is used by handle_channel_custom(),
> > > hence my comment on re-inventing the wheel. But yeah it used.
> >=20
> > Yeah but not freq_reg_info?
>=20
> That one is used by the reg_notifier() in ath9k to inspect the country IE
> regulatory domain processed.

?? It's static and not exported, so how can ath9k use it?

johannes

--=-TV1TRfCNK2B/wVRTCekk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcu0KAAoJEKVg1VMiehFYXMQP/R7dVSu3UjXJ3hJ9L2JeY89+
h4dgSV2i4mU6jFvpIyACcTo5UAQS/W3jIt45L/E/fn95GDWeFlFpYfR2WmCbZ9x7
D8+1cpM/xu5Oq0XNdGuLSQBBWlgILIFe+iWejvrDfhY3UUGXofmlhCVLbAFFRQFp
Oj1i30JmRsBCC4x9/m70COqHBQ7sZIfOTZpyEYjt+jBv9wD2sDLcdRemKJCDFaP3
tn7x3Repy1b5h04RAzo0uN48W9RWRRPDgyrl4L5BsZLBhgI0G+1KDzBlAs3Wv6to
kt6CS9mF1H+/NhO6bHNnBWRk7dhmkJWcIFMuxxbEGLLrTveVhAaQCh2p6Nk7A4FL
qQe0IrtZQ7B5Ty9QY6PNR0TlYTg1vArcz1ETpW/hs+9JlN0Q+NOgV3CwepriU4iT
uur3ccYVmlWN2f/8r8LQhIzH1kRRElPDQvjB0xVwn6NVTjwHLe0jpHWmbgaFjond
d4vSrXAuCuAm6+S5UbB1aqJ34UK9QqvaMrC7vdpFiTz25OfFfxBDlXh368aBkLeZ
p+yOYaDyn1oE3bm4O9815negd74RlyRGTS3vIPn/mipIdyzgIAFIYdRS+M136Gs0
C6k63E7g2RgdeugyzboS5zfqeCfh7yaB1r+fbB0FTo7q/1BHzZGBMQQivL+6EswZ
hkcMA7qWNrx7ExB/7uoS
=cTxo
-----END PGP SIGNATURE-----

--=-TV1TRfCNK2B/wVRTCekk--

