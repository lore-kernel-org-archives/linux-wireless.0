Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYISLyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 07:54:44 -0400
Subject: Re: technology preview: scan with cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1ba2fa240809190445v370ee80dk316d3b474db86132@mail.gmail.com> (sfid-20080919_134504_592540_694D3B3F)
References: <1221794329.10419.9.camel@johannes.berg>
	 <1221795715.10419.15.camel@johannes.berg>
	 <1ba2fa240809190103i69c66978he4762fd350ab2e5d@mail.gmail.com>
	 <1221814565.10419.19.camel@johannes.berg>
	 <1ba2fa240809190337ke17d2aanaca6d0f194b11f03@mail.gmail.com>
	 <1221820966.10419.81.camel@johannes.berg>
	 <1ba2fa240809190445v370ee80dk316d3b474db86132@mail.gmail.com>
	 (sfid-20080919_134504_592540_694D3B3F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jnG5Fyy36qwdfJfYXsMx"
Date: Fri, 19 Sep 2008 13:54:06 +0200
Message-Id: <1221825246.10419.84.camel@johannes.berg> (sfid-20080919_135450_301743_EA322F0B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jnG5Fyy36qwdfJfYXsMx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 14:45 +0300, Tomas Winkler wrote:

> iwlwifi  HW is able to issue 10 probes per channel in a single scan.
> Empirically this probably maximum of networks/SSIDs an average user
> will be interested in.   But we can go with less for example 5  probes
> per scan if we for example round robin SSID list in background scans.

Yeah but then 10 would be the number we should announce to userspace I
guess. Not sure yet.

Thanks for the info. I'm limiting iwlwifi to a single one right now and
mac80211 to four.

johannes

--=-jnG5Fyy36qwdfJfYXsMx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI05LaAAoJEKVg1VMiehFY3AoQAL/dFwWtEbBzDrOe5bE1uhvR
3/+lxkrmQGr+aD8/Ej4VqEiIbsLURmJVuCMsX8hKdi/d7ixyg8zDt1EOjGec8Uao
dxA5X4MVLvjZIgjWB5H9FlJYE/fsjLBac8SYTkE9u4FbbjXe7nSaE7vJfS+i9qjF
GQkXqGMXIxhhjYpeCklVQ0yESrlxdGaSO2SaP1MIeCeLms5HwQP/Mq2LpmK0tjvt
c69X66WugJ4uRouXCXx/9ZYXZJRgrwI5/WHXbpOOS5c0DwabZH0g03xNusLAfs49
r4dGCUuBuRAiVL0Ma1LxxsElAg9E7Vhr1UmRS9AzM8W+rdFduxKMtL6dA9Cj3Bdv
dCaNb7N0vQLKXqk3tNKooTEp4hB34CM2uvmuGFooRJN1AcDHJRLmFjoZXPKb9Nlp
YBDctEE/d4r9J+gmPkpKb6uaKM2y4D+lzdkEF8TtH0Vu53LNZgOL4WfpKzUEeOyT
yLxxkeFIKxXeKQ80P6zJe/Shg0Cc1n2kThAvxWsZFWmQ4a1qaxBkfWi/ZxkG40cX
Gxpyj+3QJFG4FZr9iLZdnXnkaZk8Ons8guAZKRMJ2RH3uaoMpxLInkHbqoPHSeFX
7Z8OwCoxLkDkjk5/m99JvZM0H/nJFCszdThhkucvV2OXRQKL1N+ssdA+3f2wrOGe
ilQwXMtgtVG3JsuYvRuQ
=6B9G
-----END PGP SIGNATURE-----

--=-jnG5Fyy36qwdfJfYXsMx--

