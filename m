Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYISKnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 06:43:21 -0400
Subject: Re: technology preview: scan with cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1ba2fa240809190337ke17d2aanaca6d0f194b11f03@mail.gmail.com> (sfid-20080919_123751_089196_5A4138C5)
References: <1221794329.10419.9.camel@johannes.berg>
	 <1221795715.10419.15.camel@johannes.berg>
	 <1ba2fa240809190103i69c66978he4762fd350ab2e5d@mail.gmail.com>
	 <1221814565.10419.19.camel@johannes.berg>
	 <1ba2fa240809190337ke17d2aanaca6d0f194b11f03@mail.gmail.com>
	 (sfid-20080919_123751_089196_5A4138C5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ta4THADysiw8Eu0S/0jb"
Date: Fri, 19 Sep 2008 12:42:46 +0200
Message-Id: <1221820966.10419.81.camel@johannes.berg> (sfid-20080919_124325_018934_D9DF50A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ta4THADysiw8Eu0S/0jb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 13:37 +0300, Tomas Winkler wrote:

> > Hey, unfair! ;) I did leave a lot of TODOs but this wasn't one of them.
> > You can provide a channel list and it'll scan only those (except hw sca=
n
> > right now but that'll be fixed once we pass the scan request struct
> > through)
>=20
> Agree, this would be the correct approach.

Yeah, but I pulled this together in about five hours :)

Wrt. the SSIDs, how many SSIDs do you think we should allow scanning for
at the same time? Three? Four? Five? I was thinking something like that,
sending out more probe requests is probably not too great an idea. I
guess we would set the default to something we decide on in mac80211's
alloc_hw and the driver gets to overwrite it if it has hw scan offload.

johannes

--=-ta4THADysiw8Eu0S/0jb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI04IiAAoJEKVg1VMiehFYBvwP/3/HyjJN7glUIWpTWQa1jZ1A
ENWX2tLvj1NaR5UCFvIf2edjTiO3WNxMyxL0D6Roq8OQF9DU9EhbA6dvRaMfQTpF
AkZIl/4V6VmNy9wbViVUWL/SsuGpQfkxY1QhXVFiERYogTYwY8/HIyfPao6hh62c
WA7eU903/1GgTpK7Rwp+Wj+7Mj4Y2hIwhDrZg38E0Bvglm0mqLwL+OFoFuTsYWys
in1DcQj36yXuqWXeZ3ozXDLHVsWksCzxWKyumulu9zYCIcwnD3yeX7KtkgBwYchx
1Lyk8kxgaruxRcZQf9Hf6kjsM3HBTBaCaOj4FUnrXJ7YuTpBw+tPKAfyGYxlJYMP
cc3aCxf8Q/z4jTVscXBdIzH8PW12aijxDINxlKzxCJ5OuymlWa1e7sKfLWathOWb
kHAMkA+MQEN2MOrMreLYFxWzV7U+ThpcunoMiiRguNpina5kp3XWWWH5FPXjnJQB
imkkAwjxImEU/7vlV7aZkJv63R1+620dh08USRcJUXwOUf3CYF3LDUmnZ2VPcZVJ
DZfym2Ol8BKOjvfRGKNAoyHvOwoGqHAVVxt4/mwyF4AQHwGxw1QUGX4Fowe5MK3I
TPcJZ4dEXMWaPxBQpNbz88TnSvVJt2aCtWLDut29wrEnj+NULXtAGPCU6MSK87GD
dIbW32wZ37d9lnMc3YN3
=5o8d
-----END PGP SIGNATURE-----

--=-ta4THADysiw8Eu0S/0jb--

