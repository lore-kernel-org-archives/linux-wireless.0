Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZAZVT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 16:19:26 -0500
Subject: Re: [PATCH 6/6] mac80211: Path Selection Protocol dummy module
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46580f6a1518f12dc2386f835865610a73d1f136.1233001803.git.flomaillist@cosetrain.com> (sfid-20090126_213928_364187_6CF41D80)
References: <497E1B90.4060803@cosetrain.com>
	 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
	 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
	 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
	 <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com>
	 <4ffda2b82d85e1a020ec30132906e35caeaa90e0.1233001803.git.flomaillist@cosetrain.com>
	 <46580f6a1518f12dc2386f835865610a73d1f136.1233001803.git.flomaillist@cosetrain.com>
	 (sfid-20090126_213928_364187_6CF41D80)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YPZ5QI9duN9Z9Zzc1M3p"
Date: Mon, 26 Jan 2009 22:19:23 +0100
Message-Id: <1233004763.4533.39.camel@johannes.local> (sfid-20090126_221930_267679_897B371A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YPZ5QI9duN9Z9Zzc1M3p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 21:39 +0100, Florian Sesser wrote:
> Can be inserted and 'used' for Path Selection
> by insmodding and issuing:
> iw dev <mesh-dev> set mesh_param mesh_path_selection_protocol_id 000F0F0F
>=20
> Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
> ---
>  net/mac80211/Makefile      |    2 +
>  net/mac80211/mesh_pptest.c |   71 ++++++++++++++++++++++++++++++++++++++=
++++++

Kconfig?

johannes

--=-YPZ5QI9duN9Z9Zzc1M3p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfijYAAoJEKVg1VMiehFYVuQP/Arv9N62stZWr+U/jNe+FsPP
tDzapXmj+jL5Nhat209TYa46imRBRR8hbadCy/I2vcYt1ugbQTM0sSfF4DLWV+OD
wKZZL5CbFx2WJXvnlzsvltWgS/ZmzZRX1AxdjlTr6xztH5Drr7FAw+/hoZQYhaSr
JZJg60y6xtu098MFmFbON8gSjYmITzCwcz0HRp+ogvl6AxsMu3BYOzLWnt3lypMY
sy7Z6EBn50yyskbCf9iyh3EpBXWWY6aiXEMfaNZbAtuvDljx/jPDbC0hHcOCnoIW
2uJo3bJm/Kt1MJvOVkKx5dZuWiNAbM/5LOS3nnIf9UMwlXgiwUZjMcH1wTHKZCEz
3PDcWhEQKM4XKUdLGx7+jlYVpln6kg1vM/VJHyjm8zCA6tW0jjAvago0lzmJCu33
Xhpa35Z/PwI+u8X2vX7vICB1rTm2WLDAtoA+gKKBoPuAraF46hSdr489utZsSMO5
PSdK5FJTpVS7yzjDkCJyHhIrLWnkvO4cegcrU4DbaViMxj95h04OoNKgriE0hzMn
zapi27ojVF7lZQA+iOC2C5sv65iStciBI9j2SAeJC7WPRebv7U/70U633xi5a2tS
b7MBDMiUGuie8BNM2OKNa5dCKcNcbvOUcurlMCNEpEt8+l1RmsLRbn5NXudtf+TU
sFz802Y2CtYvvAIOmKUj
=j57D
-----END PGP SIGNATURE-----

--=-YPZ5QI9duN9Z9Zzc1M3p--

