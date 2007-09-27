Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXI0ItW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 04:49:22 -0400
Subject: Re: [patch 6/7] mac80211: allow only one IBSS interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <242588.34302.qm@web51410.mail.re2.yahoo.com>
References: <242588.34302.qm@web51410.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dqmhhHEo8Q0+ucIACYLd"
Date: Thu, 27 Sep 2007 10:50:38 +0200
Message-Id: <1190883038.16048.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dqmhhHEo8Q0+ucIACYLd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[Could you please use reply-to-all and not break threads? thanks]

On Thu, 2007-09-27 at 01:08 -0700, Joerg Pommnitz wrote:

> Well, consider the case that you want to route between
> two *different* IBSS networks with a single NIC. This=20
> could be really useful and those a nice feature to have.

Yes, but consider the case where it all breaks because you associate to
the same IBSS. IMHO correctness is more important than "nice features".
It would be possible to fix the issue, by keeping track of the beaconing
etc. in software and having the two IBSS interfaces see each other via
software since they can't in hardware, but I'm not interested in
expending that effort right now.

johannes

--=-dqmhhHEo8Q0+ucIACYLd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+27e/ETPhpq3jKURAm8NAJ92PlYwsusfkEqpxIi5aNtKGy0SNgCghrdQ
Ah/mYcLPhNYRbPkpm5rXM+o=
=YaSk
-----END PGP SIGNATURE-----

--=-dqmhhHEo8Q0+ucIACYLd--

