Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbXCWUHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:07:22 -0400
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions  on 64-bit platforms
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Chris Wright <chrisw@sous-sol.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
In-Reply-To: <20070323200037.GA5165@bougret.hpl.hp.com>
References: <1174640787.3588.65.camel@johannes.berg>
	 <1174657362.3366.6.camel@johannes.berg>
	 <20070323154828.GA4671@bougret.hpl.hp.com>
	 <1174665384.4470.0.camel@johannes.berg>
	 <20070323161339.GA4713@bougret.hpl.hp.com>
	 <20070323193643.GY10574@sequoia.sous-sol.org>
	 <20070323200037.GA5165@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iW5MIcG7iWxZvQ9c5dML"
Date: Fri, 23 Mar 2007 21:05:26 +0100
Message-Id: <1174680326.4470.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iW5MIcG7iWxZvQ9c5dML
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-23 at 13:00 -0700, Jean Tourrilhes wrote:

> 	Let's be more clear. I tested properly on 32 bits. But, 32
> bits is not where there is issue, this issue is specific to 64 bits. I
> don't have a 64 bits platfor. It seems that few people doing wireless
> have access to 64 bits platform (actually, it seems most of them don't
> have access to SMP either), otherwise this would have been found many
> years ago.
> 	Johannes is one of the few having access to 64 bits stuff.

Few, heh. I'll give it a try next week. (actually, I don't have wireless
on the 64-bit quad powermac but I can always plug in USB things)

johannes

--=-iW5MIcG7iWxZvQ9c5dML
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGBDMG/ETPhpq3jKURAsDWAJ9x1TKrxs0xmn45OF7OFm8CiQ9Z0QCfZTVb
AHSnDIo2OwdC89lkF20gLf4=
=zj4T
-----END PGP SIGNATURE-----

--=-iW5MIcG7iWxZvQ9c5dML--

