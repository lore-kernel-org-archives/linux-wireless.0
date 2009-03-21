Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZCULId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 07:08:33 -0400
Subject: Re: [PATCH 66/77] mac80211_hwsim: convert to internal
 net_device_stats
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, j@w1.fi,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090321053717.601771143@vyatta.com> (sfid-20090321_065122_704364_56BF32DB)
References: <20090321053527.316395697@vyatta.com>
	 <20090321053717.601771143@vyatta.com>
	 (sfid-20090321_065122_704364_56BF32DB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+LgtfH3UK7gX+rqusvej"
Date: Sat, 21 Mar 2009 12:08:25 +0100
Message-Id: <1237633705.5100.172.camel@johannes.local> (sfid-20090321_120847_231687_98BA4854)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+LgtfH3UK7gX+rqusvej
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 22:36 -0700, Stephen Hemminger wrote:
> plain text document attachment (hwsim.patch)
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>=20
>=20
> --- a/drivers/net/wireless/mac80211_hwsim.c	2009-03-20 21:45:40.802964051=
 -0700
> +++ b/drivers/net/wireless/mac80211_hwsim.c	2009-03-20 22:26:02.959027480=
 -0700
> @@ -739,10 +739,16 @@ static struct device_driver mac80211_hws
>  	.name =3D "mac80211_hwsim"
>  };
> =20
> +static const struct net_device_ops hwsim_netdev_ops =3D {

this, and a few others I think, have wrong subjects.

johannes

--=-+LgtfH3UK7gX+rqusvej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxMqmAAoJEKVg1VMiehFYcFcP/35fdtwRFoILNM9hKj7kEasT
DgTYVDn4dgwbs/piT+Ob5qQnPXfGFgMDLNES9vOietk58pa3ayUJxBCfZUHy+5zg
aAh3iKoPwcci7YbHScvrRZSGMDUgjjy3hFRHO4x6VF9RVBcPZIPnzzXV739xTUG3
av/u0xTNRXwmDLvfbSevnB9QxErIzCkZ23QuuzK6OrUwGx0hblz55HvPdCnO/8Em
jEDfDQCHceyS9XEFnSURpeZ/U8mVBpHhAF7v+ARobyjDgjgJp43RbNbz5EUNA2Pm
d0NbtniYKV8FM5aA0EzZt51pDQ+beuO4GiisfXvaStHI2CtM3w2EM2pcx/tSiLyh
NfrLWZ4THQEjlcjr+0Z/APwG7t7eXnnLItWjK7RUwm/swN6WZqBqPaQjggqKWTHo
TyzYLFamEiHPIeGihLFuTejFX1S2QOrsgaSu1MnekZH9dP+m+Be7uFcsB8s8WFwI
FTe9URqw0iL9iKbhwTrkHqewm6hLPS0Ze3yS3/Ip80U6nQ0qC3KlLzkFQ/QGLOLD
QcqOfnoKITCWByBPknNy80wMpNbDQNciaK137Y9/dcTpgSAFjll+DzFPd6qQ7gfw
PJifxZU8cS+Q2D3TqoGBCMWrpn0OJszrOF6Jh81K+gK8X+647MqtKuS1zC25lCNU
K1wawfAmjy+0kOZQEF1e
=XNu5
-----END PGP SIGNATURE-----

--=-+LgtfH3UK7gX+rqusvej--

