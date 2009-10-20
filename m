Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from warszawa.7bulls.com ([194.181.28.234]:50413 "EHLO
	warszawa.7bulls.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZJTPmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 11:42:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by warszawa.7bulls.com (Postfix) with ESMTP id 7B766E7A04
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 17:19:55 +0200 (CEST)
Received: from warszawa.7bulls.com ([127.0.0.1])
	by localhost (warszawa.7bulls.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tPPVbQmY6luj for <linux-wireless@vger.kernel.org>;
	Tue, 20 Oct 2009 17:19:55 +0200 (CEST)
Received: from [192.168.14.242] (atp82.internetdsl.tpnet.pl [83.17.253.82])
	by warszawa.7bulls.com (Postfix) with ESMTP id 5315DE79CA
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 17:19:55 +0200 (CEST)
Subject: ath5k IBSS fixed rate
From: Karol =?UTF-8?Q?Pucy=C5=84ski?= <kpucynski@7bulls.com>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YuImLCOSrIKCK3L0D0Kn"
Date: Tue, 20 Oct 2009 17:20:07 +0200
Message-Id: <1256052007.5166.8.camel@kpucynski-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YuImLCOSrIKCK3L0D0Kn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

I'm trying to set up IBSS network using ath5k cards.
I'm using iwconfig to set fixed bitrate on cards, but setting it does
not have effect. When I set it with, for example, 'iwconfig wlan0 rate
1M', card is still trying to auto negotiate bitrate.
'iw wlan0 station dump' shows that it is using other (higher) bitrate
and falling down to 11M or 1M.

How can I force bitrate to use? Is there any other way?
It's bug or feature? ;)

Best regards

--=20
Karol Pucy=C5=84ski
7bulls.com Sp. z o.o.
kpucynski@7bulls.com

--=-YuImLCOSrIKCK3L0D0Kn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrd1SMACgkQp8qHnH81kyUI/gCgyge5ohAUAydQfzTq8kC+6C2S
gQAAnR2/79Ke6cw1rl+GL92D+abUT/dg
=dYVy
-----END PGP SIGNATURE-----

--=-YuImLCOSrIKCK3L0D0Kn--

