Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbXJLNJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 09:09:27 -0400
Subject: Re: atheros hardware needs padding for QoS data
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1192190297.4770.48.camel@johannes.berg> (sfid-20071012_125812_431606_A374717B)
References: <200710121946.30024.bruno@thinktube.com>
	 (sfid-20071012_114641_137646_A74F979B)  <1192190297.4770.48.camel@johannes.berg>
	 (sfid-20071012_125812_431606_A374717B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XTTrcs95QSSCnl+QgYyh"
Date: Fri, 12 Oct 2007 15:09:38 +0200
Message-Id: <1192194578.4770.55.camel@johannes.berg> (sfid-20071012_140939_766954_EFD76D4F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XTTrcs95QSSCnl+QgYyh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-12 at 13:58 +0200, Johannes Berg wrote:

> b43 also has padding added on RX which we simply remove with a memmove()

Umm, no, this is wrong, the padding is in another place.

johannes

--=-XTTrcs95QSSCnl+QgYyh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw9yEaVg1VMiehFYAQJj6A/+JjigwvHvZFTvnievrPAugr+ftuX3mznU
BJjvyNAXvuKI8T6p3c2mThnkUYLfexEsAyKHM+8docEQVu/BcZDqCWxMc446/uil
fCZetgES5zgNyeRhOVLMq0u9jmH3NOIgLz1QAf+LAcUY8sSDElogQ+fMJb3g0Hz1
PZZVBEbAFDuY/3EuWdQmfXKpVTAx5nr4ZD6Eh0SrjVgKSQ8wk3VdJXGl+DQoDa8o
GJ5gqhs/SyZxmas9wbX1sSjXK7IiwKKX+oAs6qWcgUNShlRn7nAXOFTT2eO6uGRv
4jCE6gEGidxHG/j5YIO8Q2hIXLxtrKdbDsq//LnAZ8/I5ICHj70HG1NyIGKusBpd
VKXAqwDEga5cg0vNXrau/KIYeYopZLkZMrF38e5shWK3OShFhkSajt211sx2Pj0S
mGT+K/kwLoX+lL29nFUFNTIUi0MZgUSyPKGAHc6jChk/5l0+/aJ1v/qZis/xIxso
F4r9ohjeicJO9t7RM3SBX7gJWb4xxw6UV1qcXptk15xYWYTzhqfE7KgDbcAx5zhf
S3XSlQ6sw7NUFK0kBsX1zDWSP5/PGtN9nqW5BvUONe2ExGmbsKSkAnnQ0H2m5lgH
7kLQJjTs8/bmPHy9Z3zRkG1HSADFZh9fX/amy98yVomK6d3uE7DoRagLuMMagOpD
tPqR9r2Bvi0=
=CFN9
-----END PGP SIGNATURE-----

--=-XTTrcs95QSSCnl+QgYyh--

