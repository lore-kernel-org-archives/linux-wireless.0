Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYDHOhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 10:37:54 -0400
Subject: Re: RTNL: assertion failed at key.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <47FA7CBB.4060504@gmail.com> (sfid-20080407_205822_984925_CFD8C464)
References: <47FA7CBB.4060504@gmail.com>
	 (sfid-20080407_205822_984925_CFD8C464)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RgcgbMFid2KePC1TmIMt"
Date: Tue, 08 Apr 2008 16:28:37 +0200
Message-Id: <1207664917.14253.24.camel@johannes.berg> (sfid-20080408_153756_901879_AB48141B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RgcgbMFid2KePC1TmIMt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I don't know what's the proper place for rtnl_un/lock here. sta_info_flus=
h? Or=20
> even ieee80211_sta_join_ibss and others who call sta_info_flush?

I fixed this totally differently now, got fed up with the rtnl.

johannes

--=-RgcgbMFid2KePC1TmIMt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/uBE6Vg1VMiehFYAQIqQA//VyMj0P7cI6NVTjhvphKkGP+KRt9SKGtu
pfFEdAaWkt0IP0UMriN3QZoDNwka+islJfrO+PY/E+pjQuleO+eBm7FWeRjAd1pu
JryIF0xWkc/h/Ml7NjLOP0HstFrqqzne2BpfNQU3htsS8//PAvJRD4kT4+U5BjDN
ertDKWmavxvcEUNFyRv/B3+X0QhQCU5kDleXEthYZ7MYpxKRn/7nOwR8xg9gxzA8
i8Y5gszlW9UE20APncASfmmN6Slvh+gYsThWekFG2wYxpKdVBMr4nQuVmTtSwrDB
hwxfC8WKaas5XyjHqzsKLkzu1lZuDTaKAkJAeTIKLt2v21+5j8DtkcNXCZelDL8k
M9iMDVMDxXGW5DXRgOdgKbUxU8dtK3Y/phMmDi/N1+E1MS3rLTh0cakFQ8JzxDEo
h60xhwaT+EWMOyYIxro0HyByMfGNTr09C4km92C2H9CaKnikyBRmO9gYUILpRraN
eJ/yXNWVevnaL+Lw9Oie/JQCk+IfYs8O1XAypBoVfH8LzjHf89W7pbyJmaF7d5Xs
kW7rEiO1l0lIxboTXqWO2aP6tAlBbhWiy8D1ddCBPW6zB4hwF6sAVJOH6Dd3TWMq
s+CsMM157HZp/QQr5553KpjgZhq2C9/g14tE2cqX0Cqcat6fOZoLr5r85K5KJ0/b
sg+EF0GmOzM=
=aQCs
-----END PGP SIGNATURE-----

--=-RgcgbMFid2KePC1TmIMt--

