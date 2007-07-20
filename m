Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936546AbXGTUlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 16:41:12 -0400
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and  channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Andy Green <andy@warmcat.com>, Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46A0E9B0.1050600@lwfinger.net>
References: <20070611103828.961999956@warmcat.com>
	 <20070611103914.577674038@warmcat.com>
	 <20070719191052.GC6603@tuxdriver.com> <200707192139.14930.mb@bu3sch.de>
	 <46A050B4.3060500@warmcat.com> <46A0C851.2040302@lwfinger.net>
	 <46A0CB16.6010901@warmcat.com>  <46A0E9B0.1050600@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/3yBaUoTqM2a5yFgKY3J"
Date: Fri, 20 Jul 2007 22:40:55 +0200
Message-Id: <1184964055.28598.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/3yBaUoTqM2a5yFgKY3J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-20 at 11:58 -0500, Larry Finger wrote:

> Unfortunately, that is a necessary result of this type of reverse-enginee=
ring. If Broadcom put some=20
> function in the firmware, we have to leave it there as we have no idea wh=
at would break.

:)

All we're talking here in the thread is this: go to
http://bcm-v4.sipsolutions.net/802.11/RX and you see I said "(newer
ucode)" there. We need to find out what revision that is. If people send
me a whole bunch of firmware files I can disassemble them to find out.
Or, which is faster, they can just test if they see the right info.

johannes

--=-/3yBaUoTqM2a5yFgKY3J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGoR3X/ETPhpq3jKURAjdWAJ9oY5I9O9iMVsQJhXvc5ixEc/RYRwCeJssj
o8CHsFWQsyHw/kfut3+Fhos=
=xvKO
-----END PGP SIGNATURE-----

--=-/3yBaUoTqM2a5yFgKY3J--

