Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZDUI2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 04:28:48 -0400
Subject: Re: [PATCH] cfg80211: mark all WEXT handlers _GPL
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1240276136.354.107.camel@debian>
References: <1240246179.4632.6.camel@johannes.local>
	 <1240276136.354.107.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CaVDK3vP8c+jlpXmqOM0"
Date: Tue, 21 Apr 2009 10:27:33 +0200
Message-Id: <1240302453.17388.5.camel@johannes.local> (sfid-20090421_102853_880867_3556ADF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CaVDK3vP8c+jlpXmqOM0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-21 at 09:08 +0800, Zhu Yi wrote:
> On Tue, 2009-04-21 at 00:49 +0800, Johannes Berg wrote:
> > The fact that these are exported is a technical detail
> > of the conversion period -- we don't want anybody to
> > start relying on these. Ultimately we want things to
> > use cfg80211 only, and once everything that is in wext
> > is converted to cfg80211 drivers will not need to touch
> > wext _at all_.
>=20
> Johannes, why don't you want them to be used by others, say some fullmac
> drivers? These functions can be used as glue from wext to cfg80211 in
> the conversion period. After cfg80211 is ultimately used, they can be
> removed all together of course.

I don't expect any binary drivers to start using them anyway, but on the
odd chance that somebody was considering that ... I just don't want any
arguments at the conversion point that "we still need these symbols
because we released a driver that uses them" which would mean we
couldn't actually convert properly.

johannes

--=-CaVDK3vP8c+jlpXmqOM0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7YNtAAoJEKVg1VMiehFYM2cP/33IvOybIHVHnksWIQ0FhEyc
hqfYcYm5+9QynBAx59jvPagVmR/ntKq/zPcnrXAnqWQ8ELmaAy0vVYQZg2Rl7Xzk
agRDmcN/3zeAAwiK4QHFki2oEwO+EP0md6BT9hwU1V0R5pGO7rbjw4cqftTzFxSV
SG1+canFBrlaboMlMvX14hBW5H6Vpis533oeoKP/GxYkM44BJ1cpiC8WA1Sm2vSr
gARpEthtPwRhNrQVn55JPF5xo+wUVtkXUjF99C91cRGHXcxKrx1zzLXCppUYcUT+
84Zb/6/LWt+dbSevejAJHRwv/4bF7okKqRarXSDgpRK3f/oKSdg3oWv+dtWjU1xJ
B1HfYgAfXyHSXmRnPLcLX+bQv4Yu+C1fq9UQ8zI15+T6XkUxUc4UKhmZqRIvELtH
3RJyXoXHtxnXzBE7pjD94gL3pUeXCFcx+2jviMiAVT7tNPuGywx1nB2hz9Yo5YRm
3CKR3JXCgIqNgE0I0dtIF5wupJ4OmiKEOW3lfvh5tn7E53255Yjvw9Jyo9hGWkWi
NJLF2Y2b8Rq8YrD0uWgiK8G2h1iKUrbbn25YQFNWLfh/RTn5bBjjekgq0iUMNJwZ
xa96Pe0Ud+Pnq4p1rhE1rPrbBSA/yOuN7p+ci+dXrIFpbK5vtSS1jOmwp9AH5UzF
lbm1ofJwGILIlj1vFSOb
=FDN7
-----END PGP SIGNATURE-----

--=-CaVDK3vP8c+jlpXmqOM0--

