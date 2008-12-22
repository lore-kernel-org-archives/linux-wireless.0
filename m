Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbYLVTSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 14:18:25 -0500
Subject: Re: [PATCH] mac80211_hwsim: configfs support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Igor Trindade Oliveira <igor_trindade@yahoo.com.br>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20081222085146.GC5732@jm.kir.nu>
References: <700428.4819.qm@web59316.mail.re1.yahoo.com>
	 <20081222085146.GC5732@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jo90/OfMei1acnkk+71Z"
Date: Mon, 22 Dec 2008 20:18:24 +0100
Message-Id: <1229973504.4406.22.camel@johannes> (sfid-20081222_201838_348477_9C3F5E0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jo90/OfMei1acnkk+71Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 10:51 +0200, Jouni Malinen wrote:

> Hmm.. The addition of support to add interfaces dynamically with mkdir
> sounds reasonable, but I'm not sure whether I really like the part of
> removing debugfs support.. mac80211_hwsim is a developer tool and I want
> to be able to have an undocumented and free for changes interface
> (debugfs) that does not have so strict requirement on kernel-userspace
> interface. This patch seems to also be moving the PS testing parameter
> to use configfs. If this means that it will be more difficult to change
> that mechanism or add new parameters in the future, I'm not sure I would
> support that part of the change.

As has been argued elsewhere, a few interfaces in debugfs have also
become "stable" to a point that they can't be changed much any more... I
think since this is a development tool even configfs could be declared
an in-development API?

johannes

--=-jo90/OfMei1acnkk+71Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT+f9AAoJEKVg1VMiehFY/48P/0d2S9MQSwJ7I2AL6kByrfyG
eELltg7WUY+HXKJmaWNDDv9ESNyzRidtHVrTUjz7CGuBjFevla8B3iaE672aGWGc
wtST1Ze79toAe7duX9sVoKVnMJ3s2SlGT7sf62meGdP8e9/alb+oj3UWRPHIJFWz
TDaDiykEk6QbeTmDlYwC84H062ozeG/tMDVbNecBuyyeMFf75heLlvVaX26uIvVt
sXyHyohrskUUb83XrpGG+sq5V7NsF8MkjfzFUf716Fh51rO+80E+2pQtXref2Kjr
FeR5c2vOFb8xP9/wffCa/4ws9LGd93MKd1DMbtjNv8gxFpXaQRDygH4rf8HsML+X
1agYCaUNocqSRW6GfD4B+2PTp5cp9WfLngHjK+1pnDV3UOCVfap7G4phnF9wtjOb
l44hEAB+jt0MS8h2/uenaZo5K+Xa6lMtUkDhXCtTUSAsl0v9KBtUXgYmpRAV3GEy
/QF/UrYGnN0uJo3+nlme1DLSbNiwccPqutwIuvyQyHBLOpIMjXKmFrG3GnqwyT/D
iNiw/ADMZQKgA2TyzFoWEUiwCtHnT2+8anYXj4hhgXjoF8us0ih4K5cpSmpqbUC6
Rp6og6wtdVwjjIcCbqVSGu7C/dGtmRxnrrqxlBjr1Yrwi2e7BFMXuvYKHOXjuoEw
kxRVfe4UZlq2ZFNI6Fzg
=RJ47
-----END PGP SIGNATURE-----

--=-jo90/OfMei1acnkk+71Z--

