Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337AbZAQJay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 04:30:54 -0500
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890901161413n3fdd7031lfdd0a363941b697d@mail.gmail.com> (sfid-20090116_231309_523730_F28F1671)
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232097659.3854.20.camel@johannes> <20090116163646.GG29609@tesla>
	 <43e72e890901161413n3fdd7031lfdd0a363941b697d@mail.gmail.com>
	 (sfid-20090116_231309_523730_F28F1671)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BYG5ydfzqjGqew2AYeoc"
Date: Sat, 17 Jan 2009 10:30:49 +0100
Message-Id: <1232184649.3668.2.camel@johannes> (sfid-20090117_103115_523279_46617A08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BYG5ydfzqjGqew2AYeoc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 14:13 -0800, Luis R. Rodriguez wrote:

> >> > +static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 =
*bandwidth,
> >> > +                    const struct ieee80211_reg_rule **reg_rule)
> >> > +{
> >> > +   return freq_reg_info_regd(wiphy, center_freq,
> >> > +           bandwidth, reg_rule, NULL);
> >> > +}
> >>
> >> Are you not using this or am I just not seeing the user?
> >
> > Yeah -- good catch, its just cruft left over from my previous work.
>=20
> Actually  freq_reg_info_regd() is used by handle_channel_custom(),
> hence my comment on re-inventing the wheel. But yeah it used.

Yeah but not freq_reg_info?

johannes

--=-BYG5ydfzqjGqew2AYeoc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcaVGAAoJEKVg1VMiehFYGs8P/i0MoiSU1q2wsQng3J2jAE+b
qNouA82j2bfcvEnor2Nv5YU1BVWsE0rVbkkdCR73URpaudVGpGncz5GOKksrSdjc
m2stkVSbFI2POmKYUL9QoQzh1iDJY4JQYe3sUYH9GbHAuFohyODh2Pu4egEy57Y3
4WUAi++XIwiexuQgITF5gcbZS+Pw9nK20sOQ3lZc0Ys7qkXQfhkfjAn8/bRitPKI
9xfR+kIvFECD4pOPuuwT1u4e5J5DYO1fCQ3Gg1wfsyKSp9iFjQubgktudYKcebSa
1ur774crwuXOWW+irRdvj9/NDITq0U4ePZAYGazTrmds2vt0aq8+oF3GQXAGMupm
v4H8fvi16IDM/D0QnGIEgJh58DucLMGODx7gKNFxkKRMqtyCuawkksaZ7OLVrxM2
59hd2v21cXe6OQHSDDDpFDav5wCyHbN+/lLRrFd+9LRBhgk/sMIOqCWSqBjkbPul
89NJrlgv7+fyFPYHawA5yWJQaQRzL0BUA+viTk4GAxtAQG3+1Mz9WwUaJ1Iplr6r
hqA9yxeIFRRCnQnWWFRQGPQ38nXiL9TKhqzeh3z8EcPiEO5AxhhDk2xytmJgrBx2
GGCcnT3IsoJMH08egoujGwcf9W9GT7dxo6To2U2BzPvxNoyzdmsV5SLHIjrmzNuJ
OCxieaopFS4y1j+H0pqF
=dprR
-----END PGP SIGNATURE-----

--=-BYG5ydfzqjGqew2AYeoc--

