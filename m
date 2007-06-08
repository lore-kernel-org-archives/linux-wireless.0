Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXFHTR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 15:17:58 -0400
Subject: Re: mac80211 "wme.c:398" error
From: Johannes Berg <johannes@sipsolutions.net>
To: zergavis <zergavis@o2.pl>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1279688715.20070608205031@o2.pl>
References: <1279688715.20070608205031@o2.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ocQUZ8EoqgfkKgehivXX"
Date: Fri, 08 Jun 2007 21:18:14 +0200
Message-Id: <1181330294.6533.81.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ocQUZ8EoqgfkKgehivXX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 20:50 +0200, zergavis wrote:

> net/mac80211/wme.c: In function 'wme_qdiscop_destroy':
> net/mac80211/wme.c:358: warning: implicit declaration of function=20
> 'tcf_destroy_chain'
> net/mac80211/wme.c: In function 'wme_qdiscop_init':
> net/mac80211/wme.c:398: warning: dereferencing 'void *' pointer
> net/mac80211/wme.c:398: error: request for member 'wiphy' in something no=
t=20
> a structure or union
>=20
> Could someone help me handle with this?

enable CONFIG_NET_SCHED for now.

johannes

--=-ocQUZ8EoqgfkKgehivXX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaat1/ETPhpq3jKURAjQCAJsGbz3JPJLr8ClojtXtQe5oln0PCwCeKjkZ
AzV6Cmkz4NKzZL8qFOtIkoE=
=q69F
-----END PGP SIGNATURE-----

--=-ocQUZ8EoqgfkKgehivXX--

