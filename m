Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYJ3WHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 18:07:43 -0400
Subject: Re: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810302247.28609.IvDoorn@gmail.com> (sfid-20081030_224734_416436_2229EB9B)
References: <1225361553.3690.3.camel@johannes.berg>
	 <200810302247.28609.IvDoorn@gmail.com>
	 (sfid-20081030_224734_416436_2229EB9B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pXMnojOcAAaN853sysGM"
Date: Thu, 30 Oct 2008 23:07:41 +0100
Message-Id: <1225404461.16440.6.camel@johannes.berg> (sfid-20081030_230748_279480_2A3F62B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pXMnojOcAAaN853sysGM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 22:47 +0100, Ivo van Doorn wrote:

> Heh well these 2 functions are the most important ones in the trace anywa=
y. ;)
> The only reason I see that rt61pci_mcu_request might fail like this is if=
 writel()
> crashes when a device is unplugged while a driver still has a reference t=
o the
> register base pointer which came from ioremap().
> But I don't know if that would be a valid assumption. :S

I don't think it should, at least not on pcmcia. I can reproduce and
send you a better picture, but I don't know what it'll show in terms of
"why it crashed".

johannes

--=-pXMnojOcAAaN853sysGM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCjAqAAoJEKVg1VMiehFYgTUP/RLeLoiJaZTJZqdzG7bK5O0M
i8kwnrWEAZRVX4ctmCaUNpKQrUZ+oxniSVUeaglFyiJmkSuvWCh1cpZK2meOGzU9
6JxNXht6RAy0M9r5Vr8RRavQ2aHmQUjRDuSgrg3g/OkcTFaTvztPjwrwhBSmP2x3
41Nl2EUGV6knEEdwMnfA+nTIN+vk3DAzvskcahL+SS+XlLDybvVyc+D71xEY905s
hDjaVvofL7bimgKcLV9nRw2u4jnWtij3F/tqiMd9wjuPL0bf1ac0Lkp+rJsQkrYe
IiSgAH9V1LHHtuIyCg7/WLdrwCQ1ZkgFbCeu1nJUgk476yoLRISoe1LTW6pS6P1Y
WSfNmoIX5/1sI6QVqlSsM9mvdYxwwJd6EsknA0+kDnbpEtHAWNXGncOywATtAGjo
NtTk4Z0xxxuBl7kytGLYejUv4il8sB+X8pVz+OfS2WTrpD8X/fYZpH5Ib9/7+/7z
X/SzBMkuuycEKgcxnVh/soYRV1QCsRF2j2qAV/mNGae3Dz13PsIsCaiM3jE9ztma
M1zX3v6r3TJTDHOBCi/SfvrLvOpQahpTCKW7jpKJDGQe+FuEfNf3FK5rXg6DWWHQ
V8YeyciihQ8AkP/sIhFkNcglJOkvgrjqJQngj0YVaRgC3S1zF1TPY/4UYXRHgE6d
I0i5AxwvZnA4m8GBHY+u
=1gJV
-----END PGP SIGNATURE-----

--=-pXMnojOcAAaN853sysGM--

