Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627AbYCSTp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:45:57 -0400
Subject: Re: [PATCH v2] mac80211: configure default wmm params correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <47E01816.6050004@work.ksp.sk>
References: <47DFBA13.3060508@work.ksp.sk>
	 <1205846472.16475.46.camel@johannes.berg>  <47DFC762.10307@work.ksp.sk>
	 <1205849813.16475.48.camel@johannes.berg>  <47E01816.6050004@work.ksp.sk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IkipEodqbHLOLIvprTJp"
Date: Tue, 18 Mar 2008 20:38:15 +0100
Message-Id: <1205869095.16475.54.camel@johannes.berg> (sfid-20080319_194723_972069_95B917E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IkipEodqbHLOLIvprTJp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if (local->hw.conf.channel->band =3D=3D IEEE80211_BAND_2GHZ &&
> +		have_higher_than_11mbit)
> +		sdata->flags |=3D IEEE80211_SDATA_OPERATING_GMODE;

I don't know what CodingStyle says, but I very much prefer

if (local->hw..... &&
    have_higher_than_11mbit)
	sdata->flags |=3D ...

since that visually puts the continuation of the condition together with
the start of it. Mind changing that?

johannes

--=-IkipEodqbHLOLIvprTJp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+AaJqVg1VMiehFYAQK3Ww//Wlz2/B0qVM0Y6I/X2RZAUbM7TPb2hNA9
OJxHnPbDnLP0Q4d0+wHuobpu2KB7JVa9BWmZA761YVKxl1AeRojSGmtzwdFmf+M+
qMOqnE1HEgOom6Rk/qpFy/kVJbez3wQI4ed44Abs4U5vkUX8MqDeBMdYhEmDvPQd
gEP3FzzfhU6QFp6hrEDeJyJmg3tvzbBXLU5pjUMSWCKp1Hy8uwbv8MPqXM1+DpJh
h3PmKeJ5MxUS9/RxGDRYJbuXFJYJkSem+bDbaWHyNGtTJ6sCTa2CtBqtELI1le3f
T2RDOS0Nbvoa7ZzOboNAZlUNe4ig8bESqRWJgH+MfBP3zdCiqtLjxNfCWnrH1TnF
+1NLDfMEg4IFHsJ7dr0VBP8oUby53PQYNhTOjGDbniW3ceFqrFnEeEEkQZBLtKQ7
S5dC6NrhCHPoisBbfHl10Rdg3EQYJfKOmYj2DX57M+U0FKzuBR6TPvBhbqoMv7Dq
LPXYjp6/8U1+rTwFNu8tw7TG0vw6j+TvLodWnOSbLbw0q0pPKO0a+IhmA9GL5gLn
eQOUCh0itr2Q96xEqntd/m3JwH+eokTZXwJe+B3UqFwC+57yKo8AH7/7reyh7N4l
Hkr7kSmI8eOcYZGgqYsrs0/PT9YPSH6XNmCPWhc4/ruiMtkHDI4BCq4AFV1C8yts
feyRYSrG+Zg=
=Fu1G
-----END PGP SIGNATURE-----

--=-IkipEodqbHLOLIvprTJp--

