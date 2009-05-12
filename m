Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbZELSOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 14:14:19 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Keaney <keaneyw@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A09BB45.8070808@gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <4A09B130.9000106@gmail.com>
	 <1242151180.3203.19.camel@localhost.localdomain>
	 <1242151479.11924.4.camel@johannes.local>  <4A09BB45.8070808@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HyrPpHKtwz6i5FJkP9HQ"
Date: Tue, 12 May 2009 20:13:15 +0200
Message-Id: <1242151995.14227.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HyrPpHKtwz6i5FJkP9HQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 14:09 -0400, Will Keaney wrote:

> OK. For what it's worth, the bug is still present in
> 2.6.30-rc5-wl-23297-gbf2c6a3 as pulled from wireless-testing about an
> hour ago.

Not good, but I don't care. However, you're going to have to compile
your kernel with CONFIG_FRAME_POINTER  for anybody to be able to make
sense out of the problem.

johannes

--=-HyrPpHKtwz6i5FJkP9HQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCbw3AAoJEODzc/N7+Qmam4QQAMS6vQJec1ZD0/untmMWzd0i
Qsx2iJpR5oPnuMuTwc87+D400oBWvNHjcJgDBW8D7oqakz5FYWaID2N/oLRGeLmk
zmDW0rTpKraAV/WuIbZlyBrKbvkBqRGZAijWlgjwzeuEQE+fdx4UJZTKTFxxbLC5
A5Jshmfyy+SUhlQq2fOGsYljfKsc/mUeQN4AKfWX7XqnohYBSj9RfuC2hl7nW4ti
ICFQcylK+jg8cl8u7kjyh8UZsaFXB4tHKcLSDRz+2DSoagXyw93pGLuTQluT4FKu
oojBt6ZdWRxGhnV4mt84onOaeWySbhave0ctONzgL5+nQP0TLjGjYk1u7BynUJWq
NsPxkrQrcMxnfSWg0wExvu63Rh6yPx+Hkk53C42CgZxsah+wZ2GIXSwMwIRcHiCg
X4M2r1ISOcsW7W+eusL6bFcMNQhATXu0E5JuhssEJaNVE3sEfFspgbJr7sK3cPRz
N2yXiWop4psMV6MSQLgXO5kWT/j7Wo9CftxAwjZ3RlyRMUInXES9IvRmp8B1+7IO
v7M6oF8xxaCQdTvjwPtONiKntZLsAQXZJjLWWt+9ZQSbPXCm6Cvk8lCPJdV6lh7Y
WnubZhp1Lstb06mQ61HxPEEu4Ae2Ygs+LPB87TU025SbN0CQgoe9IaWdv/UK+yNG
wrNrCnEL665ZVKqI96K+
=3oIU
-----END PGP SIGNATURE-----

--=-HyrPpHKtwz6i5FJkP9HQ--

