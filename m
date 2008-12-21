Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYLUKcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 05:32:41 -0500
Subject: Re: [PATCH 01/16] mac80211: add HT conf helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, buytenh@wantstofly.org
In-Reply-To: <1ba2fa240812201306j5429b86fv3053e1ae65004854@mail.gmail.com> (sfid-20081220_220648_068485_07672103)
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
	 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
	 <1ba2fa240812201306j5429b86fv3053e1ae65004854@mail.gmail.com>
	 (sfid-20081220_220648_068485_07672103)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0HIheTb53XJGjMr9x6xL"
Date: Sun, 21 Dec 2008 11:32:37 +0100
Message-Id: <1229855557.4953.3.camel@johannes> (sfid-20081221_113256_154981_8A4B0F26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0HIheTb53XJGjMr9x6xL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-20 at 23:06 +0200, Tomas Winkler wrote:

> > +static inline bool
> > +conf_is_ht20(struct ieee80211_conf *conf)
> > +{
> > +       if (conf->ht.channel_type =3D=3D NL80211_CHAN_HT20)
>=20
> why not just
>           return (conf->ht.channel_type =3D=3D NL80211_CHAN_HT20);

I agree, the if looks pretty odd.

johannes

--=-0HIheTb53XJGjMr9x6xL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJThtCAAoJEKVg1VMiehFYKtQP/3Ty/z2dSzjWJEqZQyuK7W8f
i9DGgqvDLPgFB3ZvHsP38MpDEGIrgCqv5kdl8LovCxKJgLFyX3UQ9z2ZGykqT/fG
i9jysHxYrk9XyzZrkOoGs2wIMxetJ8xRR7EJ8UrclLX2PbeqlxF0t25wlm+8IzlV
tsVoHRFWQAfLueatdf2CzS4BoCZwh1hxWw2i+70AeCy6gGQDEFJ5q8VDmgukfK/M
8b2GEhI6Y8Ebc6CMp5NlNQtPvvpth0Pk7VFc/eCuhBT2FrXMYJPCRQTT1PrpG02d
kuvv2BDHWvoa4frEtjMCmWtCngW0qZ5yTmJA6BHXGKIhq3jR3mwuWL3bjuNz3Ab+
drYPXm2LT7pkaDWOo+h+fRzxz8rLq+VVay9ejTZTK8IeuVIgdzAb6OluSqendxGB
1Ye6On3jGmC4VZMFAGlYNTv2Dqlm93L5Tug+Iz4Nh5x66rW2qrlAR7PinhQsLz/S
PuaUEoSy6Pu9tJLFkgI3MG4+PkydW05gaXD72OuZs9qtqvGARmmWcQi2UImzQiKp
Dr4BDZVtrX4GCUpahpav6k3bmULjaLOqJdXBuoLUUJHWqiKJKLFolHCermfmhDXw
7YR56l2qQRzF91mAqJOj5I1eAZFRRuzJ1JhA0gzphwrx1lCHX72PeT++xkjdl+zn
LizFFwUS1IfCAhNhkQY3
=IW9/
-----END PGP SIGNATURE-----

--=-0HIheTb53XJGjMr9x6xL--

