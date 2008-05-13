Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbYEMXhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 19:37:00 -0400
Subject: Re: 4311 v2 Bail - 2.6.26-rc2
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, Daniel <dan@f-box.org>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1210721604.4279.40.camel@johannes.berg> (sfid-20080514_013420_793116_3CAFC237)
References: <48294F0B.4040908@f-box.org> <200805131119.09964.mb@bu3sch.de>
	 <482A08A5.3000204@f-box.org>  <200805140127.22302.mb@bu3sch.de>
	 (sfid-20080514_012747_829356_A0E41B5F)  <1210721604.4279.40.camel@johannes.berg>
	 (sfid-20080514_013420_793116_3CAFC237)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SXS7ke6AM6xw/7tir6MQ"
Date: Wed, 14 May 2008 01:36:04 +0200
Message-Id: <1210721764.4279.41.camel@johannes.berg> (sfid-20080514_013704_757512_3567A09F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SXS7ke6AM6xw/7tir6MQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-14 at 01:33 +0200, Johannes Berg wrote:
> > Where does this "wrong buffer size" message come from, and what does it=
 mean?
> >=20
> > > b43-phy1 debug: Using hardware based encryption for keyidx: 1, mac:=20
> > > ff:ff:ff:ff:ff:ff
> > > wlan0: wrong buffer size<7>wlan0: wrong buffer size<7>wlan0: wrong=20
> > > buffer size<7>wlan0: wrong buffer size
>=20
> It comes from mac80211 when the AP is sending invalid A-MSDU frames.

Wait. If this is with b43, why the hell is it sending A-MSDU frames in
the first place? Or maybe it's receiving totally corrupt data. A monitor
mode trace would help.

johannes

--=-SXS7ke6AM6xw/7tir6MQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCol46Vg1VMiehFYAQK87g//Sg11G80+TdNnijXaanbLP0VXGTysyvzk
xdUO/IcB9J8VYmnIH9Cw+Izm6Dmfl6njLChD7Rrv3q3SjAeG5doMZsqnc1sSQTaj
jzE8YVwgub3RrLNHUOaSPeMCJKgpHhpUrIQXBtzTW3RvPUnbXDDUZGnt3X54CrmX
9P8sbyhl6D6G96w71NHuCDupw82jh6e9cH4tdscrSVz7hYgIuvGSd0Yr8v7uWGxe
iEWp+qQSrtb4+ZD04zfrTXAwqaFJTsg9Ic2cHkykNvwxAN6DK6FzDplGAWfuv5JB
5bbwo/dSdlcMTe//nq5nEuQW+GA8WozIDk0AiKrcAJxBMXi6fyWpGhSdX8PhVLV3
xkGx6FY+1s+z8ZuQazEazmLET9WTs9WZoPyCgnV0xDsG2Z5zywqPdim6n4W4nC/v
V0A5GUOTub9/8Lq9GjoUcPc9s34Gephig0Ug8qFI0vLKke+sUSdvSI2QQ8dqfMBB
F39GO42IKrvmJ7rKRKzNzCj4+901omg/Bftu5uZBF8gfTLqeE9ooYOPAwim4/FnK
Ai6BorTcgFMACLbUCG5NKQGs7T4ogHM3iuBsE86d0NJRQQbRgPvjKqD2W3ainZKd
DUMMY5lz7leIx0MCeb9NftLwRt5Y3zRoF0cRFLcl0yHX6nWpuPQnuyCy6S/KkJdy
FINjZg8td8Y=
=BYIg
-----END PGP SIGNATURE-----

--=-SXS7ke6AM6xw/7tir6MQ--

