Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806AbXHCKmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:42:46 -0400
Subject: Re: [PATCH] mac80211: No echo TX pkt to Monitor  interfaces for injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46B304AB.8060805@warmcat.com>
References: <20070802223857.19090.70108.stgit@localhost>
	 <1186135029.4647.27.camel@johannes.berg>  <46B30035.4080004@warmcat.com>
	 <1186136638.4647.32.camel@johannes.berg>  <46B304AB.8060805@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z3M+lxy83twLP8pJerNl"
Date: Fri, 03 Aug 2007 12:43:32 +0200
Message-Id: <1186137812.4647.39.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z3M+lxy83twLP8pJerNl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 11:34 +0100, Andy Green wrote:

> I also think it makes no sense to have a dependency on what Monitor mode
> provides based on the other virtual interfaces, unless the hardware
> cannot live up to the various demands at the same time.  (What hardware
> has this problem that it can't run a Managed interface with hardware
> promisc Rx?)

That's exactly the point though. Some hardware cannot do it and that's
why it exists. Not sure what hardware, probably Intel stuff with their
great firmware...

> Well it has leaked out of that raison d'etre and oozed into being what
> you get on any secondary virtual interface in Monitor mode.

I don't think you get that with bcm43xx since that allows
monitor_during_oper. I'm guessing that zd1211 should also support it but
just doesn't set the flag.

johannes

--=-z3M+lxy83twLP8pJerNl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGswbU/ETPhpq3jKURAlkmAJ9z9S8HIZPLJFGzZVjUmQKZwE1zbACfSJ59
x2KO/EYhu7F6J5R63+1w6Y8=
=FN7o
-----END PGP SIGNATURE-----

--=-z3M+lxy83twLP8pJerNl--

