Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbXKIUTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:19:10 -0500
Subject: Re: [PATCH 12/14] iwlwifi: 802.11n comply HT add station flow with
	mac80211 framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <1194595332156-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313491-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313626-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311042-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331715-git-send-email-ron.rindjunsky@intel.com>
	 <1194595332620-git-send-email-ron.rindjunsky@intel.com>
	 <1194595332187-git-send-email-ron.rindjunsky@intel.com>
	 <1194595332156-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u6r5R6v30WvUKQdLYpiH"
Date: Fri, 09 Nov 2007 17:53:22 +0100
Message-Id: <1194627202.4793.152.camel@johannes.berg> (sfid-20071109_201913_046811_509DB3ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u6r5R6v30WvUKQdLYpiH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* TODO - consider checking if mac80211 will allow
> +	 * to query its station table - will help here */

Care to explain what you mean and how it'd help?

johannes

--=-u6r5R6v30WvUKQdLYpiH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSQgaVg1VMiehFYAQLjbQ/9Hau3w6T3xFkaL9y5MM+R/W9hsWf3XRVV
MwwGnRq5BjjJZXdfOkB2P+uAaoW49QP52Sdthbg+zIyZbj8ruUigAv9VL9/R7cBx
ajYvOQvQU+0VcAwoI0qSs5DGMrkF8dnk61yiU92D0sRsbihtpyeIFxoiklzDhGB8
jqY9FxDdI7M3r5tlUWYmQ7uKl6k26e7/Kgf/uV/E2PUkEfWnyudkmLi5B6Crd5Sn
rsDRX6IxWKap2U9MqAhXRsnrLMbjh/zEXrRvUI5H3iz0kePTCJObA/KNXa/w3qwh
oqVl5yIMILISD1+Kxhg/PqpGJCGcayT4zFWAf30c+OTMl628rFwHhxKnMptNz+aS
Bj7n67VB2dWFf1c5L4NpQVe1qlCsr9AlcoqMmVD5BcfpZkHerwg7OejiQk52fNFb
egqy7RvBK1Pg8LKIfKc5b5BE4xWwHCmXaJq1P63KSsb1MtjIBQ38f4po9d1cxgxM
SZn3nZ0p3HKoG9BJSWlxTg8TLpgHud+JqcY8Vw6d0kJY/lv3Uvl55A8HoP9B0gNV
SJ/97VxbIzm0PNrahDUe1EJk3jIgu+k6dO/pz3CBTBZpwX5q4a3lWcvEfDJi164g
ADgK3y9Z9eBbS2hOQB5TnIzzvJZkGYlsObXBZPUeeYhCl49nEC1VHf4dCcsr2Rpe
VBQNrLOgmbE=
=m7WA
-----END PGP SIGNATURE-----

--=-u6r5R6v30WvUKQdLYpiH--

