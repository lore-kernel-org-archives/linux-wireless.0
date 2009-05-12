Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbZELT2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 15:28:19 -0400
Subject: Re: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <3ace41890905121208s2029db39p730b2e174cd4b1e6@mail.gmail.com>
References: <1242125077.4331.0.camel@johannes.local>
	 <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
	 <3ace41890905121208s2029db39p730b2e174cd4b1e6@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t5x94sosqewzpmkYaO6h"
Date: Tue, 12 May 2009 21:27:49 +0200
Message-Id: <1242156469.14227.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t5x94sosqewzpmkYaO6h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 20:08 +0100, Hin-Tak Leung wrote:

> BTW, nm fails to connect with
>  <WARN>  nm_device_wifi_disable_encryption(): error setting key for
> device wlan2: No such file or directory

As Dan said, you can ignore this message. However, I'm certainly no
longer getting it. Are you sure you rebooted into the correct kernel and
loaded the correct cfg80211 module?

I have now tested WPA-PSK and WEP with wpa_supplicant and WEP with
manual configuration and it all works.

johannes

--=-t5x94sosqewzpmkYaO6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCc2wAAoJEODzc/N7+QmaK80P/jLpklPnYpfBt1y8SOih2vAD
2VBIOEEgDrb0jm2+ZKPw+QY2EIL+TIg0DXldpNWJ52OAWB3jIkcoaIyKv51V4taD
uk1OvjRfYM6eZWIQLmry/AiFL6xD6GILlVih7WmZSerwPyntoLYwjy4cuKFuQ7B1
Mcas1nVqUEksMlwm2N3e2bfNOg5pCWP/OhJk+a2RdUybEplHhqGjV8/HOYmuW14L
7GSHgMJtjL9LvdgOHa/vU7TW42JueVldx/Q+EEoA9n5urFw1SZg0bh6XD8yBN38S
KiPi7tx50aXfBG+jl/hLhM/XGD6WuVdSJhxm6CMGphONq2o3oaGxmwM6pULVX+xw
+cy2IrUe+8K7m9LHmrfknMAJRgzikcqDKJLzFufGif4o2O0ozUBvbcZGi0/ddIvo
7/lumaKgIQqVPcClncnlz4g71NoFMda9uE2NeiQxkDBNsS/RvbvW4G+ZOHuhvakZ
nNywpdpcEBVDMcjg2czpt97xBEbraGylc0s2UnP4H0eroPRu61pRaFB5isrhGhyn
S2KvS8oB7d51kpX4vd2bxW8ojJlJ1ijc9+xWqMi1PmPtgdJ3Dr1bT4hsSh/LzBXl
A7A32Id07+0hrSJrcBzNyEuh7+3G2C36393HT9Z11e9+MjHqiE8/6hA+gmlJ5Ri8
uLIcq5bn9Jlh25fYALkf
=9Ook
-----END PGP SIGNATURE-----

--=-t5x94sosqewzpmkYaO6h--

