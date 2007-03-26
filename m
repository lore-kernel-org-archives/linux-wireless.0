Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXCZLYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 07:24:00 -0400
Subject: Re: [PATCH] allow wiphy renaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1174906033.1536.10.camel@johannes.berg>
References: <1172672119.5015.11.camel@johannes.berg>
	 <1172748592.11911.32.camel@johannes.berg>
	 <1174906033.1536.10.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TuDPDodm8sUpCGsm4TDK"
Date: Mon, 26 Mar 2007 13:23:51 +0200
Message-Id: <1174908231.1536.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TuDPDodm8sUpCGsm4TDK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 12:47 +0200, Johannes Berg wrote:

> Also, it changes the default wiphy name to just "phy%d in anticipation
> of Greg KH's sysfs change that will add the class name in front of the
> directory name.

That seems to be
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.2=
1-rc4-mm1/broken-out/gregkh-driver-driver-core-fix-namespace-issue-with-dev=
ices-assigned-to-classes.patch

Until that patch goes in we'll just have to live with not being able to
name a 802.11 phy "subsystem", "power", "driver", "uevent" or the same
as a netdev associated with it. After that patch, that ought to be
possible again though I haven't verified that by running it :)

johannes

--=-TuDPDodm8sUpCGsm4TDK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGB61G/ETPhpq3jKURArAgAKCiR78O2PTJmCEaDsE8uuoW/m9RYACgrdz2
mdE8wwjHWEaCyg0J50mH2rg=
=QjCd
-----END PGP SIGNATURE-----

--=-TuDPDodm8sUpCGsm4TDK--

