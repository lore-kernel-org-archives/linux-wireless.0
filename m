Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZBFOms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 09:42:48 -0500
Subject: Re: [RFC 1/2] mac80211: don't add BSS when creating IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Alina Friedrichsen <x-alina@gmx.net>
In-Reply-To: <1233917883.4099.9.camel@johannes.local> (sfid-20090206_115848_195519_25A34D99)
References: <1233917883.4099.9.camel@johannes.local>
	 (sfid-20090206_115848_195519_25A34D99)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1WNt59RMUb7Op7koWfFp"
Date: Fri, 06 Feb 2009 15:42:44 +0100
Message-Id: <1233931364.4175.13.camel@johannes.local> (sfid-20090206_154253_566929_E0CA3DCB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1WNt59RMUb7Op7koWfFp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 11:58 +0100, Johannes Berg wrote:
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Untested. Please test, also in combination with 2/2.

Tested both together with IBSS, works fine. Haven't tested fixed channel
and/or fixed BSSID though.

johannes

--=-1WNt59RMUb7Op7koWfFp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjExhAAoJEKVg1VMiehFYYQcP/jleDO0J6IllfZYcPn/GWS/S
ItItgzttC6KE35r8J4ahdzWyuDK92hi5UDJWwOvl+vVuyzUwdbba8Z5fuU3FwxOn
pKroEZdh/Qzf/ZmakCvQNmxLGka9BkPKkBrq1PlV/59S0BBv/VeY1HmUCkr1/NRD
3mlle9l72JtUoSRreVDrAkGVEbSN2ZLBrVd4h/xJVlGF3iHYYObWZN+lzJxSKnhD
R0R3wRY7PNm5Vv6iZBLRhzRE4QDBmAM3af73kwpZnaLON8Bwb2f1tOBL5zhXeCiO
ucv5Yru3S0ExoQoqnIP1THOh13cfLsbltJ8ieoD/xvrqN0WneodZ+ZlEmJ4xaSiC
HocDfqv3S0Vb9vZhBAn6ZyUsEIVb/rvi8r6OQQufUcB2Jz60f8C06Pkac0kXIYNe
y1cJGQwOX2exIpe0ED/kU5jyD+QQ+uGLVqmDP3YrN5wFsohVfwUABDlK7QAX3PDo
v66chogA3mKCfGoPqNRjE9+6a45S/Eoq15jEIcTvgfukHy4KvqJ0Dx5MLSlJ+iqT
d/nI9/UL/BlCCL0DaNcPiylrsxWvxjb9ADzEQXJu7P73nZvWW28VZxuQAfqzrwBT
PrGohVjMP1XEuz6K/RZRnjMRqp2jXX9FTnK4VoZGAK0K2zm9EnW9ooKeDIKC8vir
63DXUWvtWmLdXjAfUNhF
=2oTY
-----END PGP SIGNATURE-----

--=-1WNt59RMUb7Op7koWfFp--

