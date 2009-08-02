Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZHBJdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 05:33:20 -0400
Subject: Re: Unsupported PHY on B43
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <efe7343f0908020226n4b693defv38546a6f8aa1cfd9@mail.gmail.com>
References: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>
	 <1249204732.2007.49.camel@johannes.local>
	 <efe7343f0908020226n4b693defv38546a6f8aa1cfd9@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V+35PhHXVUO30qzsBRi8"
Date: Sun, 02 Aug 2009 11:33:17 +0200
Message-Id: <1249205597.2007.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V+35PhHXVUO30qzsBRi8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-08-02 at 10:26 +0100, Luis Correia wrote:

> > This is an 11n phy.
>=20
> Great, an 11n device with only two antennas (they are usually three).

Oh, it depends on the configuration -- maybe they used a cheaper device
with fewer chains.

> >> I'm available to test drivers, patches, git kernels, the whole lot.
> >
> > There's nothing available beyond what you have.
>=20
> Bummer, I guess I'll have to wait then.

Don't hold your breath -- nobody's working on it. I also really want it
working, but since nobody seems even interested in writing the driver,
we've halted the reverse engineering effort.

johannes

--=-V+35PhHXVUO30qzsBRi8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdV1aAAoJEODzc/N7+QmagV0P/RN8t2AhB9bNCM6RF/lWIHQU
/rWmxa3DdXSdHfct4E8CReuIhdlrAf7eOMhcAueGbLHTOjRKBBaF/k5AzUqlNZud
a64JULBcFuFnkQEq1aAd3Z3L3ORuq1A+2oq/4HbvxrkVX5tbhjA+U3zSyD+YLDfp
ydqWvUbIsSC8RQb4bmdFOlNrtAKkwJ2P9Bgb2rYhk79twe6SERe14snjFPar+Wh/
rGEjRGOGJAlsSPRb7lJvIePgeLy6bgWEqg1NzO9noSURZuqsHrIpX95r0h4yezts
ZGmU74tiD7rdwJUMcndkASeCW1P9HE3YQ0KjLMZKL/X773NCD8ULxnieKysQg87x
jvaoAwTUr6yStltTeUVqg6HFEgIDBQ2fAFwKIIzvaqgJLWzLFca/d9M13oVId59t
mvK9uTPuHzgtPclXvxec+KcHrPrPDdj7Mat6Hl3Uanxp9xL5yl1noiFX8zko46aF
M8qyvt1tk/tIVxf5GfrUR9MjmEg+NI8B770V/iEmGKS4UrCkTC9j2q3SMT0q3s0R
+ZZOVou/3xPhEkimfAgflPqM95Y8Sie7lOnTdLtVU+gUt+FWfQmROn/86O/jei6J
GU3WATwfhUocORnWPlbXrnS6MUUS3IzAaXNaQB+nilW6jhAtDvQsOGJYSQox2ELb
8ZhK2yJWf1U0ewgSlBdq
=wDIa
-----END PGP SIGNATURE-----

--=-V+35PhHXVUO30qzsBRi8--

