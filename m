Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZBLJI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 04:08:57 -0500
Subject: Re: [PATCH] mac80211: fix aggregation for hardware with ampdu
	queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <18835.43402.286764.192456@gargle.gargle.HOWL>
References: <1234396313.16004.65.camel@johannes.local>
	 <18835.43402.286764.192456@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sn7DPrF7QdnA44lyN/Xm"
Date: Thu, 12 Feb 2009 10:08:21 +0100
Message-Id: <1234429701.16004.81.camel@johannes.local> (sfid-20090212_100902_307222_0DA23951)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sn7DPrF7QdnA44lyN/Xm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 10:16 +0530, Sujith wrote:

> Tested with ath9k, works okay.

Thanks, I tried to test but am seeing enormous latencies (with ath9k)
even before my patch, ping looks like this:

ping ...
      22000 ms
      11000 ms
...
        100 ms
      20000 ms
...
        200 ms

etc.

Anyway, not a pressing issue, and not sure where that's coming from.
Throughput was good when it actually managed to establish a connection.

johannes

--=-sn7DPrF7QdnA44lyN/Xm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk+cCAAoJEKVg1VMiehFYe+kP/iRQU6WMAssfkns0Z5EFRPQB
AJ540R0JGvzRXtU0ZxnzGTVG1kKhPs9JVkElVnhiOdfmiSKA2/4mvLMeB7Se/ooI
L0eIbQx2/HUL8y161ZeR56SZJCr++f0kTCldC7BAdb/c87hRiPdbMkKvzbY9kvVM
ZKtvuL5/K8ZTSR6/48B4y8Ao5eh89ASQ8TcDCKdCeOYvj9IIz5nUmVUnkkd8er80
Gy38siGMgT84nf3Rywg5DL7XmcpvbHgOgso5m3U1AMYlrbV7OUmi3wz64k1xKKok
TyUWVa+yfxQHoVsiB2EMVKcwsZYZ2h0Y15DMCMXW6EMxGfQG/5EeTHZRxFtKjif4
qcCyyq8ZO75dbIMKXqL/J0XM7/CL7zwqVZu2pfq8y2Xws4RR2KhwBn26q32UWTTo
WnDE/LQMtlB5KqFpviDLAs8ARiOwWlhRFelge+fGzIEPLb+OeKsg0KKs62QnfKJo
UZmIDkwKV5n9uEuDeh++NRY8RMOc0FUuCzOd/VISPfaZ73SeIKcuH8mh8f+gvUCT
uRNISspckhpZhTGKlKE7yoALyIIpa1yHr7mt/O13BAl6nN7OMf0SIzFHMuC3zDc9
XA6sh4ItjMpTfSAlFYBby6PfJ1vCPSzesQNsMMAqYOyw6ZcnODv9uNss9iGGJSmw
EMPemZI0l8AQYXxLSzl/
=9eEi
-----END PGP SIGNATURE-----

--=-sn7DPrF7QdnA44lyN/Xm--

