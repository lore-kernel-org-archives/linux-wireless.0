Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZEHRaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 13:30:10 -0400
Subject: Re: [PATCH] iwlwifi: make iwl_set_rate static
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241803921.6198.459.camel@rc-desk>
References: <1241772804.1567.29.camel@johannes.local>
	 <1241803921.6198.459.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nQVY2+YCQS7sTJrVd+i+"
Date: Fri, 08 May 2009 19:30:03 +0200
Message-Id: <1241803803.4495.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nQVY2+YCQS7sTJrVd+i+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-08 at 10:32 -0700, reinette chatre wrote:

> To make this complete, could you please also remove the EXPORT_SYMBOL of
> this function and also its declaration in iwl-core.h?

Oh, yes, I forgot the export.

johannes

--=-nQVY2+YCQS7sTJrVd+i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKBGwVAAoJEODzc/N7+Qma06wP/2mKeLIwGfqMbAsRDQFBZY8a
twZaLR3Rh4wWry7UOk17/ebTyTMybwY7OZCHvF3scRoPiIBX187UuHFsFQXh3oQt
EqDA381xDv5JHYjq3DEu+9kKulgi2Mp6Lg3Vnf3YmBSeZYdXTdsetFeiOZDw/uOx
Ux/T7B5Y9mY53povhJ1dfpUCM0IfrXu0aWYYMAGj5YkWHkai4YGr9V+WBU8qohJz
41NjvRZ3rYj1+M+VXVQqhxVdgg0X1B+qaGXl5X4NKc8ANxqPMCo0/YhhmMo1hMI3
uqE7e/d1FilzI4FDuknZ2ow+bctYkSiTPiaUTqxFNBxU2w5i2uD2qspJyf5Rdgyf
x5fDJsz6DIH5j3ej8KuZUxbGcVS0xoldgL3yRdbNS0wCTb4qhSDGM1ORQElDVf58
Zz6PnDRKZZ9PQnLWd3cRKkQiETyYJ+qwh6cOsAWJCD54/atvE7LJAb04qsHDTj60
KZpHJaPBz1xKNKVjJp6wbMaAN49OQAaNLBP+3RBt6PppdNSbnVHBtce+GFhuNwBz
DXi5u+BOA0BuWowEpvxYSI3iBo0G0XP1q4AowJHfrbDX/mXqWMvdmezxe6S/AfIY
IsqMJ0vC4+gVGMinCuHX9cjDy9wg1KFjDRHvqTP0MwNvqYe+wK4DFUiFAAJP53e/
9/xLqQy4RaWEpvIwUGza
=rXu5
-----END PGP SIGNATURE-----

--=-nQVY2+YCQS7sTJrVd+i+--

