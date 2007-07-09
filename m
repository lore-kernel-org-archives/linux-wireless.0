Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXGIFQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 01:16:00 -0400
Subject: Re: Arrested Development
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Andy Green <andy@warmcat.com>,
	Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200707081544.21464.flamingice@sourmilk.net>
References: <468DE699.9040708@warmcat.com>
	 <20070708203717.GA15957@deine-taler.de>
	 <1183929814.3771.5.camel@johannes.berg>
	 <200707081544.21464.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Cusyl7U3EwlF6/Fru3I/"
Date: Mon, 09 Jul 2007 07:15:49 +0200
Message-Id: <1183958149.3771.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Cusyl7U3EwlF6/Fru3I/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-07-08 at 15:44 -0700, Michael Wu wrote:

> It doesn't allow more than one interface, sta or mntr. mac80211 does soft=
=20
> monitor mode interfaces for zd1211rw when a sta interface is already up.

Oops. You're right, I confused .open and .add_interface.

johannes

--=-Cusyl7U3EwlF6/Fru3I/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGkcSE/ETPhpq3jKURAsG3AKCTZuJEaSwRUzVe/i23H5ZRVslk3QCfdsil
UNl7wFpxukdwV7r1wnHlLUY=
=gLa6
-----END PGP SIGNATURE-----

--=-Cusyl7U3EwlF6/Fru3I/--

