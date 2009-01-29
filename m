Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759776AbZA2AFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 19:05:25 -0500
Subject: Re: [PATCH] iw: rename nl_handle to nl_sock for libnl-2.0
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4980E60D.9060505@erley.org> (sfid-20090129_001116_800094_6F18B713)
References: <4980E60D.9060505@erley.org>
	 (sfid-20090129_001116_800094_6F18B713)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/BfzVuiX+8KykxBZksEn"
Date: Thu, 29 Jan 2009 01:04:47 +0100
Message-Id: <1233187487.16048.93.camel@johannes.local> (sfid-20090129_010532_371723_16B71DF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/BfzVuiX+8KykxBZksEn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 18:11 -0500, pat-lkml wrote:
> Upstream has renamed nl_handle to nl_sock.  Update iw to the new names
> and add #define for libnl-1.1.

I fixed this already, no?

And renaming nl_handle to nl_sock means that it won't work with older,
released libs, afaict.

johannes

--=-/BfzVuiX+8KykxBZksEn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgPKdAAoJEKVg1VMiehFYRmgP/iL532hrwZLdHiT3hhYyO2nH
WiYVsZXwpa2Y69fVwGmBVLPxLpceBJ0w60TyOjUN1sJjJ4JGwlzmLJUnVqmBhr/4
deRRl3+ORdDXAnZNTdCmNLJ+zVJrWTgKE4Oez6ITIxXmL+A2LTPBlyBHbN/d6DRs
L3rIT5y01vL6qvveQfEILIW/2xwxjAEHYdwQDFsG3Bb3YGLPGa00rcX6aOiOt6Sl
Uo82DR9AG9d9DI4LAcuwDdejXVxnDAY5We6cXHqzQUxxXWKP7DSq5gpXF5T0fb71
XNp+12KCleUVTC1Q/46ec8mwwM8ukbJRxPYYoRnsyEFYAFilTEmctGbTKaBY6TlN
pR90zWGuCiXEKT+ksc3Xqe1B/5IKM3hpgqUjFyROKYeqHc8OkEDVKvFTjULSl7wl
Pw+MNtEv8lFELtAkaFS9b9k6lgYiSlf+mclhThoBwyvKwwTEgnVvl6jzWlEX73vZ
BIolFt5ZTGzTd8sgqE9QzcW6uZCpntSZ+RXb2wHa4lvpDJAmB8g7JVI5BYb8K2yG
o8J6wRX4NNRP83e9Qff3aYZdpEH0izAtRwj9z9fI1tKZxOGbjerElD5mvzS4QKAE
ekd/wsZ0sTlmYq/OZSuzbPq/scp7EExlaDRFsisQrqEDyCmI2D++jTZqm90ADtAt
8J7i5AuCDgsn2SNfxNzX
=y6TA
-----END PGP SIGNATURE-----

--=-/BfzVuiX+8KykxBZksEn--

