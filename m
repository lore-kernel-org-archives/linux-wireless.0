Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63050 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbXHJDjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 23:39:04 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: Re: [PATCH] mac80211: dynamic wep
Date: Thu, 9 Aug 2007 20:37:13 -0700
Cc: linux-wireless@vger.kernel.org
References: <pan.2007.08.10.01.03.45@physik.hu-berlin.de>
In-Reply-To: <pan.2007.08.10.01.03.45@physik.hu-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1346090.dYgyPKVaKl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708092037.17699.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1346090.dYgyPKVaKl
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 09 August 2007 18:03, Volker Braun wrote:
> This patch fixes my problems with "dynamic wep" (widely used in
> universities), and I can successfully associate and transfer data. The
> corresponding wpa_supplicant.conf is:
>
You should CC a maintainer and sign off your patch. See=20
Documentation/SubmittingPatches.

=2DMichael Wu

--nextPart1346090.dYgyPKVaKl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGu91tT3Oqt9AH4aERAiisAKC0iYG3Zsj0etjOtnYZJ5ZoC2ds+QCfc/1E
TF2oDc5hFjKaLizQvBSOviM=
=qcjr
-----END PGP SIGNATURE-----

--nextPart1346090.dYgyPKVaKl--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
