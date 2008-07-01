Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYGAKJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:09:10 -0400
Subject: Re: [PATCH/RFC v2] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	stefano.brivio@polimi.it, Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <6cf6b73e0807010305ne1c4b3bwb083c25953292f9d@mail.gmail.com> (sfid-20080701_120559_478335_D6FF76AC)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <1214906304.7763.34.camel@johannes.berg>
	 <6cf6b73e0807010305ne1c4b3bwb083c25953292f9d@mail.gmail.com>
	 (sfid-20080701_120559_478335_D6FF76AC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-meH7pvRIyPW3ftyBQeL5"
Date: Tue, 01 Jul 2008 12:08:27 +0200
Message-Id: <1214906908.7763.36.camel@johannes.berg> (sfid-20080701_120914_339386_398F0DD8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-meH7pvRIyPW3ftyBQeL5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 12:05 +0200, Adel Gadllah wrote:
> 2008/7/1 Johannes Berg <johannes@sipsolutions.net>:
> >
> >> +     rfk->poll_timer->expires =3D jiffies + B43_RFKILL_POLL_DELAY;
> >
> > round_jiffies.
>=20
> v2 attached.

That wasn't meant _literally_ but _conceptually_. You want that in the
other places too.

johannes

--=-meH7pvRIyPW3ftyBQeL5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIagIYAAoJEKVg1VMiehFY34QP/3FtzgP+NaJBaBrr16G42OGj
zFbWbk3+S+xyyTBULHA8z1Ecs2yurZDEwQ3EwOIHet11CTNR+pJa7IuHAssYkceC
NsV9CKh9B0KZr5K+g3pA46K9ilURemnEDDo5ERkzQmpLed8CoLp0SHaTuhTNgNGd
SuoEHBhGz+M6IWTmDqF2SUOxHlXRF26rfB5j0BFoTV8NmbbMYeij+pRh8liAph9T
w/WNRrbQPbu0YWu8UQAhLGz0vvOIEqS7KcHqu0U+vSmvhxuYf/sbHVrDR8g7jpLJ
+IpGe77lkC8bkoJKNJk/7eynvmTSeqDi1qX9fHFpGId+YIemk6+uiVCpDY79kI/d
MDwD90jN8NNQwtmzvSPAxW/5O3CrwHeiJlV1ks95oULwozBSEx+smwDd9d3pakDR
Hc3rpWeh0JuyTh/2AMypngDohWnrNTuER9PqBzYBNxMCTGT0kxZKx0BAcgX9VJbT
lT7Xo1L5RL50S4mOQNsgpGYyuMV7Gmn5LJ+KdPc50cxxwsDg32eFxHLQdxVJTDLK
S4q60ysFG/bhuTbWx03YejZlNzYH0Do9P3hA6VnWbDWX/ZzZMWeheHd338aM8Gln
06VmTEf87VN2ZWLmQ08IGkC1Nq09xDHEyz6ef9SjbfH1x8bGzdACe7DqPwUm9NkI
EAVsrKrbs7cb3XV+4CSb
=RRjt
-----END PGP SIGNATURE-----

--=-meH7pvRIyPW3ftyBQeL5--

