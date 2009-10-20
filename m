Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from warszawa.7bulls.com ([194.181.28.234]:59614 "EHLO
	warszawa.7bulls.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZJTP1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 11:27:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by warszawa.7bulls.com (Postfix) with ESMTP id 3B3A9E7A06
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 17:27:38 +0200 (CEST)
Received: from warszawa.7bulls.com ([127.0.0.1])
	by localhost (warszawa.7bulls.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f3-1PNKab0rK for <linux-wireless@vger.kernel.org>;
	Tue, 20 Oct 2009 17:27:38 +0200 (CEST)
Received: from [192.168.14.242] (atp82.internetdsl.tpnet.pl [83.17.253.82])
	by warszawa.7bulls.com (Postfix) with ESMTP id 12239E79CA
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 17:27:38 +0200 (CEST)
Subject: Wrong BSSID generation in IBSS mode with ath5k
From: Karol =?UTF-8?Q?Pucy=C5=84ski?= <kpucynski@7bulls.com>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0cjTSRqSXuUac48r8GBI"
Date: Tue, 20 Oct 2009 17:27:49 +0200
Message-Id: <1256052469.6550.7.camel@kpucynski-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0cjTSRqSXuUac48r8GBI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

I have IBSS network (based on ath5k cards).
With the same channel/essid set cards often can't "negotiate" the=20
same BSSID. Two nodes beside each other both create new IBSS networks
and they are not trying to merge.
Workaround: forcing BSSID with iw does work.

Do you know what can be the reason of this problem?

Tested on 2.6.31 kernel. May be related to my earlier problem 'ath5k
IBSS fixed rate'...

Best regards
--=20
Karol Pucy=C5=84ski
7bulls.com Sp. z o.o.
kpucynski@7bulls.com

--=-0cjTSRqSXuUac48r8GBI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrd1vMACgkQp8qHnH81kyUVYACcCaVzAH75zduubc06vYOz5vPU
0rsAnjKn+9tGNxnjbMFs7NzcC/Djh5uU
=tdUs
-----END PGP SIGNATURE-----

--=-0cjTSRqSXuUac48r8GBI--

