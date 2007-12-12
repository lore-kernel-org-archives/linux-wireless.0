Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbXLLRSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:18:07 -0500
Subject: privacy_invoked in AP interfaces?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z0w/LLkzz9/pYBiBCMJV"
Date: Wed, 12 Dec 2007 10:53:07 +0100
Message-Id: <1197453187.6558.88.camel@johannes.berg> (sfid-20071212_171811_071957_488FDC1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z0w/LLkzz9/pYBiBCMJV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was just testing hostapd and it told me:
Could not set PrivacyInvoked for interface wlan0

This is because we only allow setting that for STA interfaces, but what
should the setting do for AP interfaces? I don't see any point in it, is
there?

johannes

--=-z0w/LLkzz9/pYBiBCMJV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1+vgaVg1VMiehFYAQKvwA/+LhepESyxTRk+ERotcAcsDCe/toUwVl/Z
MrxNsK7pJ5GZD23U3u72Gg4UDWIzK9+kTLouU2yqoH41J7UdlkhGwuo6GhaPEYKo
5VjBy0rIVSEtw+VriVCUvdt3TY6/OsgekEuM+b+7vhchtpcxl4lMaiFju3f9FtPY
mB0XtoDPjMUZHugvTe6mL6DRaVZIpVXqN/CtgszFQQ3dfTWRo6lwbno7cvod++YP
xhmyu68sjz6P4A1QK/MSo+z7lmCIPuVXi72wjD+w65zRxpKs4MFHCKyjxJHem45A
Jcth4o7zpeHUiMjIGo4vuMFk6Ho3FqhNhbbQoJ+cQSK7aoXBvamWxgvriwSP51Da
WzOAWmlW602jy50HkO1oUHwovmGU2jvz6Y/c3kDE9m91A3syWCAbbNXlnqIUvl+1
1i5OaWQFkEFfIh+uZRzrlgXEFQIct+VBB8evlsQuuPmmjtCutsEfvgpNPM1gdRlv
sBurFscjm3RShNX4O1wfQEXyTeaSSVjLnF+ZBumyo4yEYQGOm9gzB7nGwnMxnkgN
TnEzh60Ofp7urqPf/Dd3MQId6FRHC9fdoqmejaaJ5BcHh1clerxabyG+EUPRXaIf
izOUWPDPbFG0Q0FlbbzQRk42dEsZepBpfVurgExafRgP5cSyV4/5sknaakGEJUas
W67O8vTK4bs=
=9zzX
-----END PGP SIGNATURE-----

--=-z0w/LLkzz9/pYBiBCMJV--

