Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbXC2LJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:09:05 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: mohamed <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <200703282308.43274.mb@bu3sch.de>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175106180.5151.76.camel@johannes.berg>  <200703282308.43274.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FstNg6qq/0Pqw0mL26SW"
Date: Thu, 29 Mar 2007 13:06:22 +0200
Message-Id: <1175166382.8807.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FstNg6qq/0Pqw0mL26SW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 23:08 +0200, Michael Buesch wrote:
> On Wednesday 28 March 2007 20:23, Johannes Berg wrote:
> > > +	while ((u8*)eth < skb->data + skb->len) {
> >=20
> > I don't understand this cast of eth to u8*. That seems wrong given that
> > there's an ethhdr there where the first byte isn't a length byte.
>=20
> We're not comparing the data eth points to here, but the eth pointer
> itself. It's pretty weird code. Maybe this can be solved in a
> more clear way. But it might be correct as-is.

Yeah, I read it wrong. It's fine, see my new mail.

johannes

--=-FstNg6qq/0Pqw0mL26SW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGC52u/ETPhpq3jKURAs6UAJ9wY0Q+E1mCWNzB3iTYVvrts03fAQCgs11i
Q8QS4YSzVipVi6E2+/D+Vmg=
=zCjN
-----END PGP SIGNATURE-----

--=-FstNg6qq/0Pqw0mL26SW--

