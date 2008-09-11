Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYIKShv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 14:37:51 -0400
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control
	via SIOCSIWTXPOW.
From: Johannes Berg <johannes@sipsolutions.net>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <48c964bf.1b018e0a.75a0.0ecf@mx.google.com> (sfid-20080911_203455_684983_F378BE81)
References: <48c964bf.1b018e0a.75a0.0ecf@mx.google.com>
	 (sfid-20080911_203455_684983_F378BE81)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2qKm/nWkXNs8sr2RXeiI"
Date: Thu, 11 Sep 2008 20:37:14 +0200
Message-Id: <1221158234.6986.50.camel@johannes.berg> (sfid-20080911_203754_962661_F81F5E42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2qKm/nWkXNs8sr2RXeiI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 11:17 -0700, Anna Neal wrote:

> +/**
> + * @brief Configures the transmission power control functionality.
> + *
> + * @param priv		A pointer to struct lbs_private structure
> + * @param enable	Transmission power control enable
> + * @param p0		Power level when link quality is good (dBm).
> + * @param p1		Power level when link quality is fair (dBm).
> + * @param p2		Power level when link quality is poor (dBm).
> + * @param usesnr	Use Signal to Noise Ratio in TPC
> + *
> + * @return 0 on success

What doc tools are you using? This isn't kernel-doc notation, is it?

[not that I think that should prevent the patch from going in, at this
point, since I don't think the file is read by kernel-doc anyway]

johannes

--=-2qKm/nWkXNs8sr2RXeiI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyWVUAAoJEKVg1VMiehFYyxUQALRKrcwHUm7dA4WeHje8uqdb
2gAllpOnR95QZcckkljLmb5CG7YE6I48XzHLlYiJWEOFBjsMnwWUvOGoOW5AzRB1
JfRrk0f3Avdca8hpEsUqsetsGToFKBAwKwXPbF28bQzqtcmVGsdxqxehVU6JKD1R
P9iJtWYdr7fJfGFY/GAFhWMyF2HqWNP+VRVd6BcekIoCvQAegqDxu6iYUrSeeaxq
nwUZInPqwpnSj5gwIWeCvwcPuiP2UfvIUTdFt8ljZOdx57+EnKaIa7ZPKWloRhO3
2iWdw5l/EDfpaXvdfBceb282HEgpIIBkBLOxVgNxO18t6PUCbJOED1H0XtuBaPV6
zGOjxRM9EAk2e6ZYqtBAdYD9aXkhgmYD9fFWVt0Cngys8HY4bTQjGHGXzDfh7eye
G9gOK45vauL0InfFMzXsBNGD0uBSvtBV8VPwqq/Flw6MwcrA4dL3sJ32fAPQsW75
EudELy6sHKUfOn+ekwFMdZyBlRLe+IuHSvubjbuo8KaZFRwKOJMUw9hLC5SrLTiO
8IG4xmScA5KA46BVW5O0aLcynIgximnRDHaH42h9olbhVnWAceoJaR7sk6QqQOnq
yPE13qlE+rBmVD3yC0+Tf13oogReWy+WS8EQDOK/hQnLNkLx7nhuAfMveBZDIXn2
xywnS0c8QjWUVwVqDL9D
=bNHJ
-----END PGP SIGNATURE-----

--=-2qKm/nWkXNs8sr2RXeiI--

