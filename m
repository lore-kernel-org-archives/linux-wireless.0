Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from theos.kyriasis.com ([212.71.254.33]:46227 "EHLO
	theos.kyriasis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbbBLMRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 07:17:44 -0500
Received: from leeloo.kyriasis.com (m176-64-135-147.cust.tele2.se [176.64.135.147]);
	by theos.kyriasis.com (OpenSMTPD) with ESMTPSA id 244d7f2e;
	TLS version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO;
	for <linux-wireless@vger.kernel.org>;
	Thu, 12 Feb 2015 12:11:02 +0000 (UTC)
Date: Thu, 12 Feb 2015 13:10:57 +0100
From: Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>
To: linux-wireless@vger.kernel.org
Subject: rtl8192ce kernel panics since 3.17(?)
Message-ID: <20150212121057.GA1804@leeloo.kyriasis.com> (sfid-20150212_131747_342099_FD4C74E3)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Since sometime around version 3.16 or 3.17 I've been getting a lot of=20
occasional kernel panics related to my wifi driver. My laptop has a=20
Realtek RTL8188CE wireless card and uses the rtl8192ce driver.

I have pictures of what I think is two identical kernel panics, a couple=20
of days apart:

https://lh4.googleusercontent.com/yjwOnrDmioCwuC8FqIXlKMiBTOXddLyJkWTiInJoX=
2o=3Dw421-h569-no
https://lh3.googleusercontent.com/-xM-1wSsVu4c/VKxDnlkgBbI/AAAAAAAAIng/Hxtq=
gHgglHY/w421-h569-no/IMG_20150106_212020.jpg

It only seems to happen when I have several days of uptime on my laptop=20
and just use sleep all the time instead of shutting it down.

Also I have a picture of a kernel panic that is different from the=20
previous ones:

https://lh3.googleusercontent.com/-Hj06Csglpa0/VKrI1al6QbI/AAAAAAAAImk/Vzhm=
N-dfSB0/w657-h486-no/IMG_20150105_182236.jpg

Not sure how to debug it really, but figured that sending in a report=20
would be worth a shot.

[Note: I'm not subscribed to the ML, so please CC me in replies.]

--=20
Sincerely,
  Johannes L=C3=B6thberg
  PGP Key ID: 0x50FB9B273A9D0BB5
  https://theos.kyriasis.com/~kyrias/

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iQQcBAEBCgAGBQJU3JhOAAoJEJAcHDIOsNRdQ9QgAK7favZcs7DHTCKwQfHlrVqi
YfFxTWCDiLP6+zhKal0XPVrXtKZFLzVy5DiOSsyj7Amz0Dtl0U6C/E7ThiDFZOYA
bfh1stx7CrwVNVJyuz0ka1JKhHSluA0hdRiCltPCYyXR+hwWlFeyo2MJjZI5cSph
kbBq4w2DihpflEKFGlnaavByceyyBa5ehCK0RynnTrtiThKuZ54D1AI78L3dl87s
Pz6wvax5ntFiP1PUGj5s8lE/OjZFp3cxB+x/QloOQyvU9VBtK4WffdRPFmBdiJiC
V+DKbgh6oVcrdbXtQxzkMwsrAEFAADXbYeVmEkRdxHwSHQkHgkT8srAcdIqSkhD9
wXladKmKdbbmR4nqsGSEmwxTAnUy7FIT9EviDgfd30+4sRI1rKxC3t8rntiyzfSl
KILwTjwRetV5TON+rUj8JXv6mOa6fq03sytqD7BUzx/LNJ9dgrkGzOGCYZ2yClnF
SHH61UgOQZXc2fKxWUT69oJgM6RueVVfspWxZjm1vfPUgbOh3sjUWnw1y7Z6qu5E
C7b4+kGiXpjdjU1HKe4sTXxoWRYU7w8/U5GgC4HlO+DzZzOEyRglK1MYL7ctfSIv
eEyrDGTSagoqMt5Fo/zNNTi/zbQEqdSVmYbV0b/MVFVgymKnOXyYrvtvU+z8a6jg
r+svQz31N/QcIvG4UObc6vkCn4qvJINmHe7/rDEtMCUisIMcRRt1Sgv83MYaBgRB
ugy9A5v23oelMG/WOsxcMb2xegnFs59gRRcbG34EcIPJCjjKYcdXYTy61P56rnSB
xrlLXc/DYXU9djg+noY1G7/eWuUnULl4bGX3cM+y1EXjLA3uq0aTHRKqujA5tl9H
nSOzHNP2TkD9F17h4IZeLMW+RRsQt2cXbhBjYJ9njjtoHHdJo7cXsrOzV4eG+btr
VRf0FPmYVo2NfQv69x3WGncV59f1u/DXvLFYIcY0OA6VLL80S4k530liaLWOJyWh
1mWzPB1b4LrTLAxXxon+timX+31yVSW+ptNapA3vodf8jjHGSZjRQ4stDO113Gq7
yo1/H73F7ZDZUMP/RlYnJiY6Eyngl7sg56YbaOUr2bdLxBl4fY/8Hjv4cF3tWmti
zKiUtSXrEzBARqxXxAO4pIOKZc1gXEjE1kJPy6DfY7F/VoqHqeTPpZDb2ELq+P5E
wmG5IUUPMJG6DTx4ZxT92DU1WRkDWHh1tkqXv+uRO1IiNTot4j4abKyZn2WbtvAk
Gqhof+W0msM/U6yPnWIkW8BKpdNxiuwVLCYXE8NcaF5QXXo8b3kl5WbrDLjktwuL
dzU9XtiLhxBPYBuwtoao/cGV709xWZUZTsQD330haET834JMgkP9UASrjx3v4o0=
=X8Eb
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
