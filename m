Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYBBHV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 02:21:29 -0500
Subject: Re: mac80211 QoS/aggregation questions, thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <40f31dec0802011840r56817691j3e74d3566f53bc28@mail.gmail.com> (sfid-20080202_024047_069925_BD0A9020)
References: <1201882512.4188.66.camel@johannes.berg>
	 <40f31dec0802011840r56817691j3e74d3566f53bc28@mail.gmail.com>
	 (sfid-20080202_024047_069925_BD0A9020)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HsfRUSReCjzTwRVD7Bp4"
Date: Sat, 02 Feb 2008 08:21:19 +0100
Message-Id: <1201936879.4188.100.camel@johannes.berg> (sfid-20080202_072135_139221_6480F4DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HsfRUSReCjzTwRVD7Bp4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> ACK, btw why do we have a separate ht_bss_conf which is handled by
> bss_info_changed instead of bss_info_changed or conf_ht ?

Historic reasons, it'll be gone soon I expect.

> ACK and btw let's also rename them, DATA* is not very informative,
> something like IEEE80211_TX_QUEUE_BE would be better imho

Well, I'm not entirely sure about that yet, hw with more queues might
allow people to configure them in a non-WMM way.

johannes

--=-HsfRUSReCjzTwRVD7Bp4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6QZ7qVg1VMiehFYAQLdzA/+Ljiw8JqZ8DXAijyFKrFkGOXiQp/DG7kD
B0vqBpnpxBuE8s7bdiomIgJodmSRe58I7Tz9OoFDu2jO4ViAxvK/D9LzfgOG6Idv
baOyMyO/8WaVzieT64AiQ00OZJSVwpR357vK97vCb2OD7eGmnbXF86qMNa9L66N8
zpPBHlP6PxMgxuOWq9H9ipeSBWFfC5qS0wCsLOUmVLQpQNxTV/MdG9WVaqr8YsOR
d9hHgrDsRt4G+2SsR8d5UgmmVhbM3lmN1dc7TWlhusr0EoP4ChDuAug4v5jsDRjH
z4QL0Fw6OW68BM6T+2W9XSohYTdp5/H0qHMpDy3ZHdR6PKNk2sNoF2961GidtkSn
3Y3pPHsHmqNWfL07ZQtrZoCn/zHpBNpTqC8AxvrBYMxmPgrbmIjkyn8YRJ2FtWBS
7mjhBJkOv90MLQz86vbxtc29RmbaSUy+LKTxGx6OZqNorwPYiYxZ2Rq/MF3tthOR
vqMXZhIReJQ4MimRuArU92hXz/AvpNjYXoPKOV2g58HT8N1NY9vnj2dgoByQuk2p
WSLi3/HmUQQYDy4D6TaRvaaSM+mdNha0KZWwvc3ysFuPdcMHHPLtUHQQ5zA5q67c
Tpf03TEzMai15IiWxVnnOI/QwOR+ztDwJz0wwtVFII/R1WNPaKYsenixt6W5BEjK
Id5gFg8RVzc=
=m7c0
-----END PGP SIGNATURE-----

--=-HsfRUSReCjzTwRVD7Bp4--

