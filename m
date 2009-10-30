Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZJ3UoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 16:44:18 -0400
Subject: Re: [PATCH] mac80211: make CALL_TXH a statement
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20091030191126.GC2586@tuxdriver.com>
References: <1256802228.3865.55.camel@johannes.local>
	 <20091030191126.GC2586@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HsFJX3Gbla1raLu4Abvl"
Date: Fri, 30 Oct 2009 21:43:47 +0100
Message-ID: <1256935427.3555.66.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HsFJX3Gbla1raLu4Abvl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-30 at 15:11 -0400, John W. Linville wrote:
> On Thu, Oct 29, 2009 at 08:43:48AM +0100, Johannes Berg wrote:
> > The multi-line code in this macro wasn't wrapped
> > in do {} while (0) so we cannot use it in an if()
> > branch safely in the future -- fix that.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> do {...} while (0) won't work for that either, right?  You need
> ({...}) instead if you want to return a value.  Is that what you want?

No, I just want to be able to do

if (...)
	CALL_TXH(...)

johannes

--=-HsFJX3Gbla1raLu4Abvl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK60/+AAoJEODzc/N7+Qma+68P/1m+t7UrPCe3ZJV5eb/ogDwl
E8k+qF31yYQpjq3YwzU7B0BpTc8sYOYrSo1+jR7ofKbSX9L5pYBWPRmJxNSHpa3+
2d43UWeahkR5diSANgGcV1xJipfFfkVGD67CfLI5fHZ35rWwXTgNW3Qes/UD8UNz
lwnxQHkzPaf4J0Nnx5Og2E89ShnkmW568Gc5scvUQxWyXu1fgJayjcvpheBbH23J
pXwZyL+8xUCdcFjHgiBq5IcCDiLYouhM4u8aZyy9mWBS44UTBu0MvW5UU927P84R
LNU2lAfS+DzFE3BXSyX+4VeB+G1PsiJPzemgYJg5E7xaxsMxKu6UFg6icPtVfzey
p/YFEXFWqdqYu/t1z3Gj/o7DXbL8yt0d92qk56sWls4Wq21WeSTiun3UwzEUlaYH
0mGXCgzNzKIKB3aDyarR9s8wMArmzKhSfKJtchgFsqX4v9mH3iI2X5rCfCojTX7f
RpwGJQP1ZYkIH6m+yYNzUWjme16nI4jfc0T1R5qBNjjO0+QsQcG6ZbAx5jAf5Fld
vlTiMsopuBAbY9dIcnni6lb4xoE+JP2Xm7sYau+k86IX15hNPMyIlQEWXNuoZkJ8
s0daE5I33hod9YQHMALg961jOWF6XXBSFc2FeVQISrkJkaU0qwOopMn9djHa33AV
wZ7SIq5LXL93gRpmJBLQ
=vdzd
-----END PGP SIGNATURE-----

--=-HsFJX3Gbla1raLu4Abvl--

