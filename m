Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213AbXCHTkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:40:14 -0500
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: jt@hpl.hp.com, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20070308193412.GG23040@devicescape.com>
References: <1173144447.15891.93.camel@johannes.berg>
	 <20070306171316.GA19669@bougret.hpl.hp.com>
	 <200703061943.07350.mb@bu3sch.de>
	 <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
	 <20070308184954.GA24485@bougret.hpl.hp.com>
	 <1173382042.3248.63.camel@johannes.berg>
	 <20070308193412.GG23040@devicescape.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AQ2J+NA0w52xtbr+ov3N"
Date: Thu, 08 Mar 2007 20:40:01 +0100
Message-Id: <1173382802.3248.68.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AQ2J+NA0w52xtbr+ov3N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 11:34 -0800, Jouni Malinen wrote:

> Yes, workaround in just iwlib is not enough. If the only possible
> solution is user space workaround, it better be documented (and
> communicated to maintainers of user space apps) well so that
> all user space programs not using iwlib can be modified, too.

The more I think about it the worse it gets. Think about wireless events
where both 32 and 64-bit userspace programs may be listening... That
means we can't even fix it in the kernel without breaking something.

johannes

--=-AQ2J+NA0w52xtbr+ov3N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8GaR/ETPhpq3jKURAkspAJ0eKz/C5kNMF2fmYcHhBdxs2S+yVwCggqKo
a3rmXJie8QsxDNHH6YhGWMo=
=Hxg6
-----END PGP SIGNATURE-----

--=-AQ2J+NA0w52xtbr+ov3N--

