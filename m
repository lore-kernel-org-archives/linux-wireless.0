Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943006AbXHML2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 07:28:40 -0400
Subject: Re: [PATCH] hostapd: work with monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Andy Green <andy@warmcat.com>
In-Reply-To: <1187004511.27916.95.camel@johannes.berg>
References: <1186992004.27916.53.camel@johannes.berg>
	 <1187004511.27916.95.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RZlUwy84SOBssTF4ENh6"
Date: Mon, 13 Aug 2007 13:31:04 +0200
Message-Id: <1187004664.27916.97.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RZlUwy84SOBssTF4ENh6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 13:28 +0200, Johannes Berg wrote:

>  2) make sure that we don't copy each packet before stuffing it into a
>     monitor interface. we now throw away packets with BPF but we've
>     already copied them, that's rather wasteful. We should be able to
>     get by using clones.

at least until we need to actually change anything in the packet, which
is hopefully rare enough

johannes

--=-RZlUwy84SOBssTF4ENh6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwED4/ETPhpq3jKURApCgAJ9ZFVQciMlAl02P9LQKqLvrKjpBxQCfTeVR
IQFiV5pNcT6tNaUnCn4mP4I=
=Miv2
-----END PGP SIGNATURE-----

--=-RZlUwy84SOBssTF4ENh6--

