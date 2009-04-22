Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZDVKGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 06:06:24 -0400
Subject: Re: regulatory db: MAX EIRP for BE wrong?
From: Johannes Berg <johannes@sipsolutions.net>
To: Hans Maes <Hans@bitnet.be>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <49EEEB4D.1090104@bitnet.be> (sfid-20090422_120235_353092_B8E19A8F)
References: <49EEEB4D.1090104@bitnet.be>
	 (sfid-20090422_120235_353092_B8E19A8F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-M2oskLppl34V1pVidK7o"
Date: Wed, 22 Apr 2009 12:05:51 +0200
Message-Id: <1240394751.21978.2.camel@johannes.local> (sfid-20090422_120627_963064_40A3AEA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M2oskLppl34V1pVidK7o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> According to=20
> http://wireless.kernel.org/en/developers/Regulatory/Database?alpha2=3DBE=20
> the max EIRP for BE (Belgium) on the 5490-5710 Mhz band is 27dBm (500mW)
>=20
> I was under the impression that it is actually 30dBm (1W) on that band,=20
> according to BIPT (Belgian Institute for Post and Telecommunications)=20
> regulations.

It is very like that this band requires TPC, which we haven't
implemented yet (but Cisco would), and w/o TPC the regulations halve the
TX power limit.

johannes

--=-M2oskLppl34V1pVidK7o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7uv3AAoJEKVg1VMiehFY/UUQAInnYkW1/n6MtL5QpxZEXM3L
pM7brPbvNP6UfwB1sVkfS0kVH8IBdJLkzxAVWpMu+JItIr/F/EHMWYDWP81FwXaM
GgGbIidiq/Eu2EYHYqzQFQbEW4UHMT22SegE2lzSIoH/zBPb6gNXy+3XWUVo1uHf
GY16KkJ5CP5YTn4lVPjz72WGHkAIw/CpnySyqswueuVlckLdbomCtcfkFB7dcP7i
9m2SOrRRDmBxB+oaJwEoIOTWu312d5w3/VZZVgaNtDjzoCF2dGXhxWDU156oOlrO
S/4Msbr+So3KqX8mOZuHNs2RJRPrhgJHjt/tZjHEO+bazYICQZqn+5jT24rVaeLS
rlqWnyRaXmoZwLPcZd47Lfm/CumRgc/g6UP9xmHORdD6ZQ86aZLAkZhD1qptmpBx
QkcXASHuwZmZghCmySO5maxR2Q/4YWUtvPsgIaYFDIvUc9aKQJdEQBchkNIVQ5Ea
T5cCoN7uQ5xh1JMbFSiqQ8868UHwdPdDA6jL/z6MIYzP9DEySn8C3Din/Yy7doHY
By1gt3dLtjUaCurGiR1FxjJgKKokiXNlaLwNOp/tdYx3bsrQAPZ5mbB422W54Kmi
e4G83/v5QExQNEC9h5P8Zq2Y6u7sVf2xT4eW80c72UOK9fa12xnCyZ8tBxPmrGtr
SlGGPznmwtyqUKgw9kl9
=cQsz
-----END PGP SIGNATURE-----

--=-M2oskLppl34V1pVidK7o--

