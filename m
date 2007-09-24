Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXIXIlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 04:41:23 -0400
Subject: Re: scanning implementation and sta matching
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200709231832.05498.flamingice@sourmilk.net>
References: <1190330446.18521.120.camel@johannes.berg>
	 <200709231832.05498.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9lLsbvp5nV3Cf2msTKvC"
Date: Mon, 24 Sep 2007 10:42:45 +0200
Message-Id: <1190623365.18521.240.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9lLsbvp5nV3Cf2msTKvC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-09-23 at 18:31 -0400, Michael Wu wrote:

> Of course, this is with the pending-mac80211 series in mac80211-misc. Did=
 you=20
> break scanning in some other patches?

Oh, of course I wouldn't post such patches; I broke scanning in later
patches when I tried optimising the frame->interface matching.

johannes

--=-9lLsbvp5nV3Cf2msTKvC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG93iF/ETPhpq3jKURAkwZAJ0RuuHvVM6AKfRTxgX1BE8xw2nltgCeOnNd
RZ8wV7HygoTkgaDqZjuoZTs=
=PGVr
-----END PGP SIGNATURE-----

--=-9lLsbvp5nV3Cf2msTKvC--

