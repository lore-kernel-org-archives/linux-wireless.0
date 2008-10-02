Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYJBJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 05:25:00 -0400
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
From: Johannes Berg <johannes@sipsolutions.net>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <87od23mo08.fsf@denkblock.local> (sfid-20081002_095349_565298_98E6BA33)
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	 <200810012055.58085.toralf.foerster@gmx.de>
	 <87ej30m376.fsf@denkblock.local>
	 <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	 <87ljx8ndw1.fsf@denkblock.local>
	 <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	 <87od23mo08.fsf@denkblock.local> (sfid-20081002_095349_565298_98E6BA33)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JXaU5QsWuSTNej9GAyBc"
Date: Thu, 02 Oct 2008 11:24:28 +0200
Message-Id: <1222939468.24551.36.camel@johannes.berg> (sfid-20081002_112502_575097_91796C69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JXaU5QsWuSTNej9GAyBc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-02 at 09:53 +0200, Elias Oltmanns wrote:

> So, if higher layers won't provide any information about what interface
> is considered opened, then ath5k has to track this sort of state
> information itself if it intends to resume to the exact same state of
> affairs as observed at the time of going into suspend.

Well, if somebody would just fix suspend/resume as I've outlined
multiple times and is on the todo list...

johannes

--=-JXaU5QsWuSTNej9GAyBc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5JNIAAoJEKVg1VMiehFYA6sQAIb8k6Mk+ijX8BvzBftK8XA4
e0ImgK3Wzx18E7ZahTubAj30qDEkHY77CT8etGa6nS/gbQCExdFwU85QvrNfDrBl
46hVUPj23emHSsS2m2fBnK9X81zzsotMSnKIp5kcAieCdK7SJrvffDt+u1ORi8DH
+gMLnTP/L0uW7gMo3VL2qIkXl3JPl2aJy439sT49FessTflYOGMRLpXPCf3UMbvK
mlEecaZTqDBQds815G09XaGYTk+8WUQIJxQJw9c6HCaTpjO1C6vc3uSPnY3OTKZ5
gJIk/kgMdku+vReF+79MD+BpJVZHVLXr1AIpXu7ITRc6Y6KfASdK8Yvoy1k9khrt
1tTHfOZRpt+oyb2waBJRRryUbGnL8KYFus1H5KS2L9lINQM098yA1T0C7cbT9T5t
TVBCiBbO5lkWLGf7s9jvAZbrELTsKyghIxC2wYGFz2dN3wu3bEGyD0Fzl4OrK0GT
wi2IOdDBO1or8jgOLUu72ZhQ370UYCK4G+9OlvsAWWln4yjMZPY2KS3BUzDS2tHr
v+yoN7snAEZwQKuRLDN7zEhAh6b90TgHSrrrfW3Fmo3IQypmWdp2fBD/M/KR/7RR
nTeHK7C4gU+Z0YmMxlwkEPASxr7w7MarjWkFg2u1cKEjlRyP+dWT0Q3nxiUkXKR+
IQtQU1ORKHVcBfGvY0nH
=6Z9l
-----END PGP SIGNATURE-----

--=-JXaU5QsWuSTNej9GAyBc--

