Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161806AbXDZJjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 05:39:42 -0400
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070423184814.7029.8413.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <20070423184814.7029.8413.stgit@magic.sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cAn67agjbY2qAn6UqoE8"
Date: Tue, 24 Apr 2007 18:20:55 +0200
Message-Id: <1177431656.3528.33.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cAn67agjbY2qAn6UqoE8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-23 at 14:48 -0400, Michael Wu wrote:

> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -23,6 +23,7 @@
>  #include <linux/wireless.h>
>  #include <linux/random.h>
>  #include <linux/etherdevice.h>
> +#include <linux/rtnetlink.h>
>  #include <net/iw_handler.h>
>  #include <asm/types.h>
>  #include <asm/delay.h>

Nah. Is that missing from some previous patch?

johannes

--=-cAn67agjbY2qAn6UqoE8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGLi5n/ETPhpq3jKURAmjOAKCIGVCPNO8IC9HDT8DutZNdhQ6oTwCff2oD
5Ipr8fuuu4W0g6Gq7uJ817U=
=H8Az
-----END PGP SIGNATURE-----

--=-cAn67agjbY2qAn6UqoE8--

