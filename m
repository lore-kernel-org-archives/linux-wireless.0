Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZLLLoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 06:44:02 -0500
Subject: Re: mac80211 noob question
From: Johannes Berg <johannes@sipsolutions.net>
To: Vitalik Nikolyenko <vnik5287@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <-3945137922086923095@unknownmsgid>
References: <157c4da70912120218lc53633bk62fc9ee99377a231@mail.gmail.com>
	 <1260613513.2442.319.camel@johannes.local>
	 <157c4da70912120329n4b6bc663ic47e95201f7569da@mail.gmail.com>
	 <1260617445.2442.332.camel@johannes.local>
	 <-3945137922086923095@unknownmsgid>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vWQyxU6AJErmdLZjIpaC"
Date: Sat, 12 Dec 2009 12:44:05 +0100
Message-ID: <1260618245.2442.333.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vWQyxU6AJErmdLZjIpaC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[please trim your quotes]

On Sat, 2009-12-12 at 22:40 +1100, Vitalik Nikolyenko wrote:
> Sorry for not being very clear. I'm capturing on C and just want to
> check if B acked A's frame (if that's possible)

Oh. Of course, just check if you see an ACK frame. You can't see whether
it arrived on A, of course, or if maybe B sent it, A received it, but C
didn't for some reason.

johannes

--=-vWQyxU6AJErmdLZjIpaC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLI4ICAAoJEODzc/N7+Qmalg8P/2IZdV1bmxNNf0DHNOM8N4Vp
9C6EgBDxqBQUG8rnfYJ0OW0sUuDu0OeJdjJCfmEiAyjyIN3H9L9q0WT/Ixs7296Z
UPZWppe4t1/qPEMf5vHWKMeQZyem3ZLUqpEejr6F7cdAm9IsYw9aAqbHmYoSOizE
YnyJ97GKHKOHhHq3leD6vEP5dlXJiEXeqZblmd5I+tkHg9ES7NBBzgGR16rKgOyW
5fcS1LDpZ2n8KPwlNEiD8VQxuuFsxq1hxng4gdZq73PWNtjO0NDYV0T+mpSRxwLg
YOw4ST2qX98b0TlNXmbAlqZmFAH8sDxI4wVx8ZIDG4MEDXjOBwH0bm+r5OTBbwHF
Dz8YspCjXoeSYEbe2eJXeq0VyOHdZsQl2N6pJEA6Qo6RYajjpCs4BM6xViGxWwC6
ArXiq+lrwnNRfQZidjGJ3pYoVdfFFVDFtUhCPyonHeejGA23o1YfygDLj8MogxlA
XLjpZNEWZUirJUQPj8Ya+4gwaQJbTbcaFX0F2ls41Opcs/9dxpGpcB9txVtIVrpy
72Q1V1Q4VWmNx0AMklOGffsSJ8FuOWgzb5GTRKegLXyv5IvNIRJF8a4Z/czcWWEa
o+Gpi55z/AJhGiWXYflZ78/kIIRbGbqb6lS6tftWiD7oOxGqSlF+dKjP6wuvon8U
5g07CTB8majKaXQQH6vQ
=+AMO
-----END PGP SIGNATURE-----

--=-vWQyxU6AJErmdLZjIpaC--

