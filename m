Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXFVKL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 06:11:28 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200706212205.16642.flamingice@sourmilk.net>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621133556.GJ5361@jm.kir.nu>
	 <200706212205.16642.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sa2cCDrzBI9b8ZXX3lsL"
Date: Fri, 22 Jun 2007 12:12:35 +0200
Message-Id: <1182507155.21939.91.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sa2cCDrzBI9b8ZXX3lsL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-21 at 22:05 -0700, Michael Wu wrote:

> > - receive data frames EAPOL/etc. ethertypes in decrypted form
> We should be able to receive this on the other interface which is handlin=
g all=20
> the data frames, right?

No, they need to be dropped by the kernel in most cases afaict and
should never make it to that interface.

johannes

--=-sa2cCDrzBI9b8ZXX3lsL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGe6CT/ETPhpq3jKURAkgaAJ0W0E0MAURsiXE6rZmth+TM4WPYFACfZCr0
z56gL0qg/aV57Kx7reAs2vs=
=PZlR
-----END PGP SIGNATURE-----

--=-sa2cCDrzBI9b8ZXX3lsL--

