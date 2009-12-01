Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZLAS2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 13:28:04 -0500
Subject: Re: [PATCH] mac80211: allow disabling 40MHz on 2.4GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1259691446.4806.12.camel@mj>
References: <1259688582.32171.97.camel@johannes.local>
	 <1259691446.4806.12.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qHdQw+gg5WNEwZMLuZgV"
Date: Tue, 01 Dec 2009 19:27:33 +0100
Message-ID: <1259692053.32171.98.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qHdQw+gg5WNEwZMLuZgV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-01 at 13:17 -0500, Pavel Roskin wrote:
> On Tue, 2009-12-01 at 18:29 +0100, Johannes Berg wrote:
> > In some situations it is required that a system be
> > configured with no support for 40 MHz channels in
> > the 2.4 GHz band. Rather than imposing any such
> > restrictions on everybody, allow configuration a
> > system like that with a module parameter. It is
> > writable at runtime but only takes effect at the
> > time of the next association.
>=20
> That looks like a hack to me.
>=20
> Maybe it should be treated like other CRDA flags?  In fact, you can find
> this in dbparse.py in the wireless-regdb sources:
>=20
>     # hole at bit 9. FIXME: Where is NO-HT40 defined?
>     'NO-HT40':          1<<10,
>=20
> However, there are no other references to NO-HT40 in the wireless-regdb
> or CRDA sources.  I assume it's not implemented.

It's not a regulatory requirement, it's a coexistence requirement.

johannes

--=-qHdQw+gg5WNEwZMLuZgV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFWASAAoJEODzc/N7+QmaIksP/3BY1vQRL77qsiLHFuvvlN19
/lPj8ig4uKp9SJyTuFrkr6kOgVGz/RfOdKGforTh1H2KnGTr5tODss7Fmr+mdP7l
BAaBgS0OPtVFxwiftWcwlhPgfTx9D1XrdiTOZTr4Azzjq022MBJBveAvJ741yEHb
KhndPurSF1CwfoHj1gRofrwmUvhag4KeFusI5NQwAUohUqA/zM443syJ1G5LB5Ko
nQa0MQvLN4lXCaRnwLu3WQPdVu7lejmirzHqAY3A8osQ4udpJB7nZcpSHYD9owoo
kW3bFuTL1MFbONqEA8WantZAdKm67fBL3FuLPPB4gcuS/w8EfEPBi7/LUGBB1EYj
fLEdtN78YndmEQeD+lt91MfT6AbwGMRnnae4JC0YMdiNQ2+jq9qfMPZkHanpiNEY
1RCak+QguNtnXH9Uhc8mARxVs9gSnSTxMqEk6rm/TWdL5rQ0TIPizxE8axxUxxFq
iAlM2nZIRZ8ZYrfhE4HgZuUy4Jd7ST9toAm+FWBnIDJExlR63r0XgmvwdBH9V8eM
TNTQqVxLPghllkal+A5ShwLwCZANYXRpoJLtIpj6n6feESofC4jIHfdt5GDzz5kK
Iru6ntglV3ZQkUa3SpcArAcigB8+NJ298dn5sFY0XZb87fOgKaLiQ/PMdDNSihFC
a+9GC0d8ANmOkKXmbOw7
=i5dW
-----END PGP SIGNATURE-----

--=-qHdQw+gg5WNEwZMLuZgV--

