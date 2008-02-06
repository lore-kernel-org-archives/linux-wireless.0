Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbYBGKfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:08 -0500
Subject: Re: [PATCH 01/13] o11s: (rtnetlink) add commands for mesh tables
	manipulation
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a7825b.06538c0a.3bce.5ec1@mx.google.com> (sfid-20080204_212408_298998_A7C8CED4)
References: <47a7825b.06538c0a.3bce.5ec1@mx.google.com>
	 (sfid-20080204_212408_298998_A7C8CED4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v4ukEUsWgYY5IAQaXNq7"
Date: Thu, 07 Feb 2008 00:56:48 +0100
Message-Id: <1202342208.9965.29.camel@johannes.berg> (sfid-20080207_103518_757679_24F70555)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v4ukEUsWgYY5IAQaXNq7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-04 at 10:48 -0800, Luis Carlos Cobo wrote:
> This patch adds the necessary commands for mesh peer link table and mesh =
path
> table manipulation.

This needs to go via netdev too. Also, why should it be defined as
"real" netlink rather than within nl80211? It is wireless specific, no?

johannes

--=-v4ukEUsWgYY5IAQaXNq7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pJP6Vg1VMiehFYAQImTg/9Gzx7GYwfXK1BNjxrDwJgeQ2h7tMmPb0S
PgFWSrt0lwdx2PoT6YX8/depuZgbfKVHAo7Mu/tHM8VzJ5I432fNCBfEvET9k4gk
4Kbuhe4HkUt6epnBLjk+tlilXnsTGO2IkphAIwC5PvZaj3wfmdILlWopn4RtZbqi
lMOKjAwRaGOAeoRGT7luQuSVp4RrIdqnOhTdv457+eK1n344coFXtUqNmrFkfbYl
ud26P0XJGC0TB8T9nHfILnjvo2TEp0CD8VjUozt4mZ8uc5nokyE3M2MnhFYiQTob
9tB95UH+sx5l5pWXiYK5L7EokUO2lUl7i9Gz4YeqqiaXLfICt7DPzbumVm6NUAz2
kkCLNgiq4Lsk/94hrB7zYGcpXpKNl/HSfzl3Obey5iLT0PDYuwiASUburBN0op9a
jrseYyb2QeziFUKAWuGeTsjUjfp4ubVlHPgzyRY+9M1wIjrnVP+oLZXu/JqyB3kj
Cnr2sEGwel2o+RgUVo0t9vl7r5Z82sEPKLmqNMKzx/kMmWJGjY3Vy/FzUYhM3WU+
L5LO9NtUFFVerhvewQxbi4CK5zhjNiR0ufkkBquzPP5tTzvys2o2CpXvagRUsr8e
w3VSb3iem4ja/hL3NTzosFxXdDBvrVO5byja6cawlAJB56PkLAT9iKYcPdXbuAyE
VuulRTRIWkw=
=saYV
-----END PGP SIGNATURE-----

--=-v4ukEUsWgYY5IAQaXNq7--

