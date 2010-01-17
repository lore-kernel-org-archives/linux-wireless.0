Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab0AQUOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 15:14:41 -0500
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the
 operating frequency and export it through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B536F21.1090509@openwrt.org>
References: <4B536B05.6070301@openwrt.org>
	 <1263758236.28067.11.camel@johannes.local>
	 <1263758423.28067.12.camel@johannes.local>  <4B536F21.1090509@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+eAMdHrraPVFUmh87i4Y"
Date: Sun, 17 Jan 2010 21:14:38 +0100
Message-ID: <1263759278.28067.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+eAMdHrraPVFUmh87i4Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-17 at 21:12 +0100, Felix Fietkau wrote:

> > If you have an IBSS or managed mode then you know from the BSS info
> what
> > channel you should be on... APs are completely userspace controlled
> > anyway, so are monitors.
> I was thinking about scanning, but then again, that's not handled by
> my patch series either. I'll simplify it and make it per-netdev.

But scanning isn't really interesting, it might be firmware controlled
or whatever. What do you need the whole thing for? Why export the
channel at all?

johannes

--=-+eAMdHrraPVFUmh87i4Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLU2+nAAoJEODzc/N7+QmaK3UP/0/lZvNKC+AasJhhvsUJlb1L
K82LUaFm15OnH7kjIeZcUuLMruGgMSQVn22HwdsXOH+bDY/sYsBo+jalBf4fv1bt
b0XR9RJHWDY4Ng4vZHmKHR/9Ic8CmzNywSqyg++rq8KHRhLkwl8hqQN4AhJ3Er0F
l2Aw1D3HCt+1D8P4lFtNacOlcBy9ZvLhLQjJTNeU0g6GMoHRO4DCbDRsOJLSGmjw
KjiLnmC5Hc+02NYbBJ27BCL7sTkquRfb+Kp6NKQ/KnMVrjf6xHeaBCrLMNxvjZ5O
9qCJme5OO5AQDejcgHcNbMcEijgyG2rExYQVJdbXL4Q/PXUlmzP3I3YXIlyNLhVD
+ad5HVOknksbamAnFn8zFnS5LXO1Pv35O2McK/NBQwAJktKVlVa0yke9bllOmqap
7+Dswf0lI3wy8T+xXu8Ci7kqcGhdEcej7TX/ba6oEwgpDuVOEnzZWbwNEqGt8XkG
0iFQXX0rAPEih21ArT/8cSfYK+gfgBDeMD5amL0sDxFpr20OZDUvi0knT9vha58R
zceTBAmym/Jc4VKYUKCLmzYvMPTRjo5VWd8Gp+XI7PwQsKogEiBaZBHtDF58ZNzP
wg6GOWULZLbeIJnZkA/qnRgyfd8dz47NjBerOpajNZdwksp5qjz+bYl8Bn64mDx5
zgcjwSYNqqs8Pv9FdAbE
=afO+
-----END PGP SIGNATURE-----

--=-+eAMdHrraPVFUmh87i4Y--

