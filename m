Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761605AbZEMWU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:20:26 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>, Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090513214004.GE26299@khazad-dum.debian.net>
References: <1242030669.6930.10.camel@johannes.local>
	 <4A09B130.9000106@gmail.com>
	 <1242151180.3203.19.camel@localhost.localdomain>
	 <1242151479.11924.4.camel@johannes.local>
	 <20090513214004.GE26299@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dvXEC3/cwnT7FQColkax"
Date: Thu, 14 May 2009 00:19:52 +0200
Message-Id: <1242253192.10076.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dvXEC3/cwnT7FQColkax
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 18:40 -0300, Henrique de Moraes Holschuh wrote:

> Hmm, I did get your email, but I am overworked and nearing a burn out due
> to real-life issues, so I didn't answer right away.  I will see if I can
> get something usable by Sunday (I usually get some opportunity to unwind
> and work on the kernel during the weekend), but I will not complain if yo=
u
> come up with something quick-and-dirty should I fail to deliver.

Alright, thanks. I just need to get this done to post it for .31.

> As for the issue Dan reported, I have _no_ _idea_ of what it might be
> causing it, and a bissect would help wonders.  It will have to be fixed
> anyway (even if it is also fixed by the rfkill rewrite) if it is hosing
> 2.6.30 :-(

Dan? Now I'm confused? You mean Will's issue? Does thinkpad do LED
stuff? That's the only thing we changed recently in the current rfkill
code...

johannes

--=-dvXEC3/cwnT7FQColkax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC0eDAAoJEODzc/N7+QmaONEP/jdTuL56GjIFiPxxc/dqgmFR
q2KT4watiN6GtW6erBih0xcE7QyWjKJ3yL3KgMDaA2EyVF6gwyvvXGeCurk1pO4S
pV+vn1qFJdSd0gR97C/JuS8QG5bEzpxy2ZP9c/9KmHGBHJmeroDLrdoNzQX2zWlZ
PvpNh/Zdi79IKV6YMJCeV5oURXOBeMkZT93oKtrWAKILyfXhiENkeF5axq2eFEN1
O8leIQldS6GjVhsI3Vt1MttAZefIcCThHiipeaRxAYFinJwAlunUBWBjQMXsT6CY
D7Auoeby8zVyBvmewGC6wXJUnyAB5L5On1xch1W4CoakqWaUbdjxGfyofs9F3GFe
o1r3RDOasxEYBtbe3dGjoYr9ZqIJH8ZRAIjLo1PC12jPYOUDopCVsEAN2l9bVVRq
oOuc3GKITkcR5HrrXa2llMyerSrz2VYXCpT+dNtOBCVj0Uo06H2kL6ZP6Wmze+LQ
JFAIH3lCUPL31GvFRSagNYGidevjFzo+s3ycciYgsFaRFC/pFvIPvwpYNrPct2Ph
BLg1sB537hawHqbHd69Yiq2AFcd0cebVNBZNuGj/wcApnKGBziZTSKBGLuQBtytw
3FB8/HaiVnn5Xd/pRMJrFMlgS/B67c3D8Iq3KKqAgDLI3zgybUJHpi/+zgB21A0V
NzR0IaRNUK3Vd45RCYJo
=mgXa
-----END PGP SIGNATURE-----

--=-dvXEC3/cwnT7FQColkax--

