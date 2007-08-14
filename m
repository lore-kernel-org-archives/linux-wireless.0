Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbXHNO3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 10:29:05 -0400
Subject: Re: [PATCH] mac80211: don't send packets to interfaces that are  down
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1187101721.4069.48.camel@johannes.berg>
References: <1187101721.4069.48.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d2801qENEWKpe6lWeXmR"
Date: Tue, 14 Aug 2007 16:31:11 +0200
Message-Id: <1187101871.4069.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d2801qENEWKpe6lWeXmR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 16:28 +0200, Johannes Berg wrote:

> Is there a possibility of a race condition here? If the interface is
> brought down right after this check the SKB could be copied to that
> interface after the skb queue has been flushed.

Oh once we sort that out this should go to all applicable kernels ASAP,
including -stable I think (this is in stable right? :) )

johannes

--=-d2801qENEWKpe6lWeXmR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwbyv/ETPhpq3jKURAqbSAKCCR325yJVwRDBGKguAf1j6Mwc6LgCfeg5P
52Wj4T2gJpY+7iinRIIT/Hw=
=yPgl
-----END PGP SIGNATURE-----

--=-d2801qENEWKpe6lWeXmR--

