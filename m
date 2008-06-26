Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYFZNdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 09:33:36 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: cs010101@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <1214449044.18897.15.camel@dv> (sfid-20080626_045727_909115_82C1268F)
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <1214449044.18897.15.camel@dv> (sfid-20080626_045727_909115_82C1268F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RzY3W8YUa9hh6/pbKNXw"
Date: Thu, 26 Jun 2008 15:33:20 +0200
Message-Id: <1214487200.20763.44.camel@johannes.berg> (sfid-20080626_153339_999895_B5B131BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RzY3W8YUa9hh6/pbKNXw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 22:57 -0400, Pavel Roskin wrote:
> On Thu, 2008-06-26 at 11:54 +0900, =EA=B9=80=EC=98=81=ED=99=98 wrote:
> > Hello~
> >=20
> > Lately, I've researched for AP mode in linux. I'm testing 802.11a about
> > atheros 5414, rt61, zyDAS USB(a/b/g).
> > I know AP mode are supportted on Prism chipset, Atheros(madwifi).
> > then how the nic using atheros 5414 chipset?
>=20
> mac80211 based drivers including ath5k don't support AP mode yet.
> Please use MadWifi with it for now.

s/use Madwifi.*\./help fix mac80211 AP mode./

johannes

--=-RzY3W8YUa9hh6/pbKNXw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY5qcAAoJEKVg1VMiehFYCl4P/1CqlxlIFEe5q6EpfuPiZ2ji
vicDXJL62GeED/S3fS4/KW0GXQNyN6r/bmBiwM0+FGwmsBvg37G17SWlEtDkmkZa
ynQxEQ+X4OjJ6gO4bgJ4SR+nTCE2rBv6hqNTAJsz5N1c/NNBfoyiKmSEoqaaKq00
6QM7yHk0qSRCi1zv7k+0N9ytqXrcK6R8W6zzTcbAGlpMttik9sjGQX4C9BA4xRMW
VCAZSZNBmInlWSOEH67vi1UVuAruej9vE4lfEgQJ93VJzV11L+GN6amLYPTyBel/
ZQSAP3ChANuy31HLiURtPM6pTwSM9jqAbVlHD2z4/5jng7ZunfzVXWa51bMkIbVc
r/iU930HZpJ6eGoDuoZh0Ms1aokUBdGGVoot1W8GwYugZOO2XZJauzJ+iOXs2cXY
DkNKH4grSXLALS2rRq07kdzVvM8ubGAsEoTkquxepYR82yg0cJ0y9L8glvdbc54b
Z9BAhRsnTD5mot2vMhbMvycWU6CAT6Er98cZCJTy9Qd2xvKmHAyRCK5p0v+PwplY
zfJykqo8c4zcLu65B2SmNScNkGx7IAt352Ppm7ruO+blUxvNvS4ewXS6fFsb9jBW
dJFw7bcDD/ch2fafgXy3D5EtGYs/8hb0W/9/iasUvP2n5ztJIeQHuGQ87fUavgN7
YI95uKLDg+FkIx0CzjAd
=Tcly
-----END PGP SIGNATURE-----

--=-RzY3W8YUa9hh6/pbKNXw--

