Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767648AbXDFNw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 09:52:27 -0400
Subject: Re: [PATCH] mac80211: Add radiotap support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Andy Green <andy@warmcat.com>
In-Reply-To: <200704060926.21863.flamingice@sourmilk.net>
References: <200704060048.51524.flamingice@sourmilk.net>
	 <1175847074.3489.56.camel@johannes.berg>
	 <200704060926.21863.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-91f31UO/anzxWs8Rl936"
Date: Fri, 06 Apr 2007 15:52:16 +0200
Message-Id: <1175867536.8459.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-91f31UO/anzxWs8Rl936
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-06 at 09:26 -0400, Michael Wu wrote:

> > I don't like this trick. It's so non-obvious. And inbetween, the only
> > thing we ever use is skb->data (once, to get hdr assigned) and skb->len
> > (which we could also load into a local variable.
> >
> This is actually being done to avoid modifying rx_pre_handlers.

Ah, I missed that they were called inbetween.

johannes

--=-91f31UO/anzxWs8Rl936
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGFlCP/ETPhpq3jKURAjAyAKC4dFJ5g5YwxEbCYANkAJ7Xl0kYcwCfWAqZ
4W0DvrD9fAkQwYG3Rv097Kc=
=1qzc
-----END PGP SIGNATURE-----

--=-91f31UO/anzxWs8Rl936--

