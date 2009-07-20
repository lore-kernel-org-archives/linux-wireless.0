Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbZGTKhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 06:37:25 -0400
Subject: Re: [PATCH 3/5] iwmc3200wifi: use cfg80211_connect_result to send
 req/resp IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kuQlBAaatQ8jQ2FarqWO"
Date: Mon, 20 Jul 2009 12:37:21 +0200
Message-Id: <1248086241.14765.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kuQlBAaatQ8jQ2FarqWO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-20 at 11:47 +0800, Zhu Yi wrote:
> cfg80211_connect_result() let us specify associate request and
> response IEs as parameters after we are connected. We use this
> capability instead of doing it ourselves with WEXT.

I think with this, you can now remove

        select WIRELESS_EXT

from your Kconfig.

johannes

--=-kuQlBAaatQ8jQ2FarqWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZEjdAAoJEODzc/N7+QmaChcP/jaVPQ2lx9GcfSTT0zn7v6sx
LWKSeS4LJwcvFcUfGlIFAgL9guvrhXj+Odxhf6WvCH1Cq2jh+oaynM4uisJ9tT8V
B4E3Qmk6O9Ub1k96ox7iziX6hCSU1p0j8Q7/SuBuLrtpLaHwwiuLRvPAGXI5WxdC
4Rt4ZYnpTh7Aw7z+iVS/DxR1i5WkPGspNbgTmgUMBzrvnMyjvq78T5pwdu5524B+
AAcjc8cxTOGldi6waF4blevqIsc4QQGdaMs7ubP6DSICtnrSNye5H2dueAhjVUGR
c/xSCYG4ErF2W8qVue+PkZqhKLwcxtNG8rp/VMNMOnmrJ8dgKvtCQvRtwNluZiCt
Ydj1yi25ctpN9OndBWe+mRAc1h1Wrw2rkG1rYFitDegp6Sm3+0Rw3gULgU6FA+tr
ZY2SUhEkAZPnj5dx/o+Np4DdmbNM0kzEABgxawM/u8CcJyaPoid21rCzasggR1Yg
9vOGUtzcYd30aXDYdpuY0jP9VKz0XcayLuCPTUdRZ7oOTFqOfSRJZbh9B2FP9m/H
6h5crJ7E76OJLZVGv7M9WayrCHy83I7V5Cqc1ZopZpHteULpQmqdURbyQUlKRvDL
bC5ko1Iny0p4f6eiOaz1OuBabXeB5l6dzjGY1o2j9Edr4DF8QsZUg+fYrrB+Nluk
2f5UVAriZOiQlvZ2f6by
=6/q1
-----END PGP SIGNATURE-----

--=-kuQlBAaatQ8jQ2FarqWO--

