Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYIFRTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 13:19:40 -0400
Subject: Re: [PATCH] Ath9k: Add RF kill support.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <1220721347.6714.114.camel@californication> (sfid-20080906_191538_728310_1EC0FE5D)
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
	 <1220721347.6714.114.camel@californication>
	 (sfid-20080906_191538_728310_1EC0FE5D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yAjsWVCj+7ofkCvaG7NI"
Date: Sat, 06 Sep 2008 19:19:32 +0200
Message-Id: <1220721572.10102.0.camel@johannes.berg> (sfid-20080906_192003_595621_9791F144)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yAjsWVCj+7ofkCvaG7NI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-06 at 19:15 +0200, Marcel Holtmann wrote:
> Hi Vasanthakumar,
>=20
> > CONFIG_ATH9K_RFKILL needs to be set
> > to enable this support.
>=20
> why do we have to introduce yet another config option for this? What is
> the advantage of disabling RFKILL support? I really don't see it and all
> these extra config options are rather confusing than useful.

"if EMBEDDED", I think you may want to build a router without rfkill
stuff.

johannes

--=-yAjsWVCj+7ofkCvaG7NI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwrugAAoJEKVg1VMiehFY4S8P/3efaPTiVgd6oD7Dcl1e+JyK
JkWkRSvW2JseDQcwD1AhwALPMTN6bO1Ypq/8CO54aQCI1DLa+LDNCJYIls94HJPC
6Iygu+pW/sOdt7vX6nPJAMbTvHjw99TBz+QgNrhwIGbgylmoGEkxKeDbRi5L097o
3C+pMP+Vv+6qH64tOepKrK/t8YAYSdvUIzD0qfId4ZrnJTGD85ika5RFhiGnyvPn
BcEG+N+v/kX28gfnxkHypzvHMKZrKGfCnd67UZOdmKlsJAvfKX0q8oYqyFz/gUEB
TExv9qWT6neVWUeKhsRf4wzGVZJzY5hU89u6dZNv5qS6AeBSU383wECRl1jo7yRx
5hcRRIek8gyc8Oi8f6eTBgoDM9D1HgMUbx8he7fHaoKxkEHpw51+7sXsiSDL6Vko
NbIu7rNTx+OWYM4QqZ9DVip7wScTark4aJY0AXeXBfWvwG7FcPPc7NynXyYj4wu4
TNjatfM+vFeF45kRWR9/QRCxDwK827aepOPQMD8d96Vb+RNQAg/pQdW1+TFF6Xcw
ENNDKoCfQDglNjDj0ecUM0HKC0BZvGhunzPAt8u9+BGOXVH38mvmzHTD8cRcY/7a
WO6f19MUmPfjeuRiI/MeLeZ+Y8M2mQ614KQoKk+LWXEH2GC8Elov+AB80g0pTtE9
jHrIJpRwIvdepEKqs2aV
=GGqk
-----END PGP SIGNATURE-----

--=-yAjsWVCj+7ofkCvaG7NI--

