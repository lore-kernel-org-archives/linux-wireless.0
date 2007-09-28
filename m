Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXI1LaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 07:30:14 -0400
Subject: Re: Error in compilation of b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46FC854B.2010500@lwfinger.net>
References: <46FC854B.2010500@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fFHGDwml4eFoN0y81W8S"
Date: Fri, 28 Sep 2007 13:31:32 +0200
Message-Id: <1190979092.5021.37.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fFHGDwml4eFoN0y81W8S
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-27 at 23:38 -0500, Larry Finger wrote:

> drivers/net/wireless/b43/rfkill.c:112: error: implicit declaration of fun=
ction =E2=80=98rfkill_get_led_name=E2=80=99
> drivers/net/wireless/b43/rfkill.c:112: warning: return makes pointer from=
 integer without a cast
>=20
> I assume that I missed some critical patch. Can you tell me which one it =
is?

Looks like "[PATCH] rfkill: Add support for an rfkill LED" might be it.

johannes

--=-fFHGDwml4eFoN0y81W8S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG/OYU/ETPhpq3jKURAmBrAJ9dLrQiYClSJPRVfyXkR92MEizP4ACeIgZc
v5hfxyk7PDZ4QHBf+NJLC2Y=
=dOSU
-----END PGP SIGNATURE-----

--=-fFHGDwml4eFoN0y81W8S--

