Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030490AbXDZKLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 06:11:55 -0400
Subject: Re: [PATCH 0/9] various wext cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	jt@hpl.hp.com
In-Reply-To: <20070424180732.371620000@sipsolutions.net>
References: <20070424180732.371620000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dJkxM2oE5Eyru+mYqkKu"
Date: Thu, 26 Apr 2007 12:15:13 +0200
Message-Id: <1177582513.6814.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dJkxM2oE5Eyru+mYqkKu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-04-24 at 20:07 +0200, Johannes Berg wrote:
> This patch series contains various cleanups to the wireless extensions co=
de.

Patch 1/9 got lost because it's too large, but it's only moving
net/core/wireless.c to net/wireless/wext.c and doing some tiny Makefile
updates.

johannes

--=-dJkxM2oE5Eyru+mYqkKu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMHuw/ETPhpq3jKURAhkUAKC0muJ6P5nvNAtAfQ2WhJL232G/9ACgh8lO
ZtDfnXLTMm4MRTFYxjWgkG0=
=xZCw
-----END PGP SIGNATURE-----

--=-dJkxM2oE5Eyru+mYqkKu--

