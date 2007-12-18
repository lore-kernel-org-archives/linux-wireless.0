Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbXLRPv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 10:51:26 -0500
Subject: Re: Queries about acx-mac80211 master mode support on the AR7
	platform
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Williamson <mark.williamson@imperial.ac.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4767E141.7080801@imperial.ac.uk> (sfid-20071218_153428_191906_A6890286)
References: <4767E141.7080801@imperial.ac.uk>
	 (sfid-20071218_153428_191906_A6890286)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VrO2gEZY/BRdrLtyyTj0"
Date: Tue, 18 Dec 2007 16:46:05 +0100
Message-Id: <1197992765.4885.173.camel@johannes.berg> (sfid-20071218_155131_301671_E9DFAF86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VrO2gEZY/BRdrLtyyTj0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> But, perhaps the largest sticking point is that the acx-mac80211=20
> driver, unlike acx, does not support AP (master) mode. I have struggled=20
> to find out whether this is an issue in the acx-mac80211 driver=20
> component or in fact the mac80211 does not support master mode at this=20
> moment in time.

Both, I expect, though I don't know about the driver. I'm currently
working on a large patch series to make mac80211 work in master mode
again together with hostapd, you may want to search the archives of this
list for my [FYI] mails on the topic.

johannes

--=-VrO2gEZY/BRdrLtyyTj0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2frPKVg1VMiehFYAQLBQRAAoFFw9xFOiZH77BnYuDiMlMGDNscLYS/p
cS/xdJ/ytIMnne5aQQhpgUMrpAszG1vpvFA07wRj3lz719380l6kFHCXQVjDHWUr
n4LonN9FU7XUl6NxKMFephWREgySQfDNk8VgIDIrBc3zp8ks+gq7UPlPZ2Un+PoM
qdLL53yrO4IihxYPtPgOMS3B91M9RNn7e1ymy0MCO0mF8wiz/abUkW66Tl874qRi
heFNG+XHWY6rgxnLhvaGV7bO9oKQQMgAZgP+rCMAo30Wu6sDkQn4e3HU/komVLSA
BqcywHCDmGQwbCL5pW+W3VdpnHhPIzq4xX79MW+J/CCa9sfVBoM3hp2ixeVvKa6I
sQ2gO1/dMf4RuEQSnVndVY1wRNPYMg/ztnd0qfeYbdKh2YroSxaitUjUbHvHPUhR
lY8Rf4PM6SFcUlYAOZjXW17In2T34bRRudcg8kYFXmxUSNTTP3yjtZkrN2VR9sqN
GAWnLqR6TnwkQivioGIaeEFPAmoIXN1hrxMw5A/wvMJxFEMAS7c79a+vBMKrKmMU
j3bTJY8LgoA9mgedMF+Asqlg5vlMfYY0NeF51IWUu0zL8o5Aa09bH8FJGhh0K71G
wxdAihOeEGzYCUzC3V9PUybBjdhuybYVv3g+Cgd+HsfLHKwAQDzKbsYIQz/J/A3x
3Dsp9Tn8kg4=
=MKoT
-----END PGP SIGNATURE-----

--=-VrO2gEZY/BRdrLtyyTj0--

