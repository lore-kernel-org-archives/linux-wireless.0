Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbXHPNOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:14:09 -0400
Subject: Re: [PATCH] mac80211 & drivers: remove IEEE80211_HW_HOST_GEN_BEACON
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200708152016.07188.IvDoorn@gmail.com>
References: <1187134461.31200.32.camel@johannes.berg>
	 <200708152016.07188.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+pWbsLyOyDjCxHLXxGMv"
Date: Thu, 16 Aug 2007 15:15:48 +0200
Message-Id: <1187270148.5141.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+pWbsLyOyDjCxHLXxGMv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 20:16 +0200, Ivo van Doorn wrote:

> I assume that mac80211 will always provide a beacon to the driver when ne=
eded?

Yeah.

> I mean during config_interface a beacon is supplied for master interfaces=
 and this
> will kick the beacon handler for rt2x00. (which also assures ieee80211_be=
acon_get()=20
> will be called when the beacon has been send).
> But for adhoc this will still be properly supplied through rt2x00pci_beac=
on_update() ?

If it works now it'll continue working since that flag was never
tested :)

johannes

--=-+pWbsLyOyDjCxHLXxGMv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxE4E/ETPhpq3jKURArRQAJkBpmIPGXkOyI8liZyjnWIyfbWNcACgr3qU
3FdAvIsEXwYfXeb9Spi/pzk=
=f9mA
-----END PGP SIGNATURE-----

--=-+pWbsLyOyDjCxHLXxGMv--

