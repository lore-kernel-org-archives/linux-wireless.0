Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbXHUKOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:14:24 -0400
Subject: Re: [PATCH 05/20] mac80211: remove unused ioctls (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070821030918.GM1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145043.551508000@sipsolutions.net>
	 <20070818040423.GF1415@jm.kir.nu> <1187601005.6090.41.camel@johannes.berg>
	 <20070821030918.GM1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GYFAavU0UTR0uggYkOTy"
Date: Tue, 21 Aug 2007 12:14:07 +0200
Message-Id: <1187691247.4288.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GYFAavU0UTR0uggYkOTy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 20:09 -0700, Jouni Malinen wrote:

> Sure, that's fine. I was mainly objecting for the part of completely
> removing the code (i.e., not just the ioctl). I don't really care how
> this command goes through, but anyway, I would agree that debugfs would
> be more reasonable location now that it is available and already being
> used elsewhere in mac80211.

Ok. I'll update the patch to move that flag instead. Though that has me
thinking, should it be a per-netdev flag rather than a global one?

johannes

--=-GYFAavU0UTR0uggYkOTy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyrrv/ETPhpq3jKURAhW/AJ4tL5vA5DSBRGR8Zry/6UUdBPc4pgCglE/Q
PB1DeT5gXx+AF6yevOZUdR4=
=XxEM
-----END PGP SIGNATURE-----

--=-GYFAavU0UTR0uggYkOTy--

