Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762421AbXFEOQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 10:16:10 -0400
Subject: Re: nl80211 status? (implying cfg80211 status)
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070605140924.GC5221@charon.n2.diac24.net>
References: <20070604193034.GA16350@charon.n2.diac24.net>
	 <1181040798.8274.10.camel@johannes.berg>
	 <1181051870.8274.17.camel@johannes.berg>
	 <20070605140924.GC5221@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3IIZ/HszJH8Ejv7Nng92"
Date: Tue, 05 Jun 2007 16:16:17 +0200
Message-Id: <1181052977.8274.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3IIZ/HszJH8Ejv7Nng92
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-05 at 16:09 +0200, David Lamparter wrote:
> Hooray, message crossing :)

Heh.

> Yeah, I agree. Guess I overshooted a bit on converting wext. For the
> userspace part I started by adding some genetlink helper functions to
> iproute2, will try to get them upstream later. (tomorrow)

libnl already has generic netlink stuff in its svn version.

> I'm hoping to add an "ip wireless" part, since iproute2 already has all t=
he
> netlink stuff and I really like its syntax. I rudimentarily started hacki=
ng
> it up, which is why I noticed there's no PHY configuration command.

Nice. I'm not too keen on having it as "ip wireless" since it isn't
really much related to ip. But if you want to work on it and decide to
put it there I won't stop you :)

> For the kernel part, if I were to work on it, I'd be adding it to mac8021=
1.
> The only 802.11 devices I own are a laptop with a rt2500 and a WRT router=
,
> and developing for that router isn't that fun.

Well rt2500 with mac80211 sounds good to me, only some fullmac chipsets
would be able to interface with cfg80211. Oh and that WRT router
probably either has an atheros (no useful linux drivers) or a broadcom
(bcm43xx/bcm43xx-mac80211) chipset.

johannes

--=-3IIZ/HszJH8Ejv7Nng92
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGZXAx/ETPhpq3jKURAmDKAJ4wFVjDqIumlp6pOqrz0c8KkKsUvACfe3Fe
mjqnJsrcMzsBBHZx3VEDaKU=
=l448
-----END PGP SIGNATURE-----

--=-3IIZ/HszJH8Ejv7Nng92--

