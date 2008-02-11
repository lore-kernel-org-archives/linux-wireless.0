Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYBKMWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:22:48 -0500
Subject: Re: [PATCH 05/13] o11s: added mesh.h, mesh function and data
	structures definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78274.12025a0a.0fb8.67db@mx.google.com> (sfid-20080204_212415_776178_13DE2F2C)
References: <47a78274.12025a0a.0fb8.67db@mx.google.com>
	 (sfid-20080204_212415_776178_13DE2F2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/854zlAdLO1aIBAboLRF"
Date: Mon, 11 Feb 2008 09:25:15 +0100
Message-Id: <1202718315.11481.22.camel@johannes.berg> (sfid-20080211_122251_323768_11A4EF0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/854zlAdLO1aIBAboLRF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +struct ieee80211s_hdr {
> +	u8 flags;
> +	u8 ttl;
> +	u8 seqnum[3];
> +	u8 eaddr1[6];
> +	u8 eaddr2[6];
> +	u8 eaddr3[6];
> +} __attribute__ ((packed));

Btw, why not add this to include/linux/ieee80211.h?

johannes

--=-/854zlAdLO1aIBAboLRF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7AGaqVg1VMiehFYAQL/dQ/+JwXFB33I57zpprqMAaKlcP8b27rLONWi
5Zigh70a8AO89SFIS/UHR5eIuwVOgNTiVDSCiQC4WqyYfQrcVeZn1X4J76Vri69A
lKH7xJeeOgg4fwtEq2oiXH1l/5+1t5JUIqjHhF+0w74IFq+EZD4dNI5JnL9IHVhy
Whkj6A6KgltRc/dbgyelbAuNpUA/GjfPh4ylPjUHHNsOLowSIFDNAQojqMMCbyJr
DwnCHhoWq3Lf4S1bpL866ufLuWen1jIZ8ys5Gl0qtbIIZcdbm3oqkxFBXEuKJYxo
tcaMhXhbBY3iPGtPISJTz9Ln2uec2HdCRc0ZZoz9D1teGrIhqGSWD25tilweP8rT
Nn12AhoMfgCV/7Ng+A++UtNJxVkDfhfaBKruTEqUqczetI9sI7L+0w5hJ6a7wlpT
wkkGSq1HyHNNJZwdIi51ubV5eprufI0pcJOIKmrFWZ7k7jblw7XmpARJX1DSo6uZ
/ue0po1gImhmoPXxIm24u1FztSwSrSAWtw8QjpcnaS0OuQji2aazNm/T3j7Rwlor
IOsrhKFQYD6RW9+10unZcPSxZlJfo8RTqIYKVICpRskiwWT63qG7KEtGsZyU+/Xj
b6y6VOJ372OCA2Z/FYa8Hca+6bfd6EZ+xkyDsQLS4h1t+5MwQftyVbI5SCP0KYbt
be6pp7/3ILo=
=L542
-----END PGP SIGNATURE-----

--=-/854zlAdLO1aIBAboLRF--

