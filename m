Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab2JQLvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 07:51:52 -0400
Message-ID: <1350474742.10728.14.camel@jlt4.sipsolutions.net> (sfid-20121017_135157_227600_D8E71CA9)
Subject: pull-request: iwlwifi 2012-10-17
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 Oct 2012 13:52:22 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Y8OZb/S4Fi+UrSSdItRd"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y8OZb/S4Fi+UrSSdItRd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Please pull my iwlwifi.git tree to get a single fix (for RH bugzilla
770484).

johannes


The following changes since commit bf11315eeda510ea4fc1a2bf972d8155d31d89b4=
:

  net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()=
 (2012-10-15 14:45:52 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 8f7b8db6e0557c8437adf9371e020cd89a7e85dc:

  iwlwifi: fix 6000 series channel switch command (2012-10-16 16:28:36 +020=
0)

----------------------------------------------------------------
Johannes Berg (1):
      iwlwifi: fix 6000 series channel switch command

 drivers/net/wireless/iwlwifi/dvm/devices.c |   39 +++++++++++++++++-------=
----
 1 file changed, 24 insertions(+), 15 deletions(-)


--=-Y8OZb/S4Fi+UrSSdItRd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQfpv2AAoJEDBSmw7B7bqrKZQQAKHKPXORg31x+6+GTei/BWQH
5KwjoE+RtTmwDe1/znDfnXfwybUp4RnWEibUk3S7Qja0gmTrp5sKSrN4Gtr4UhjQ
M3Yu+bXHnIH1T/gXGfPPtmJgOAq4W1PTSrI6nGViaM/vnn+f0HGBFtf5J11oD2lo
rtbT+tO0L/LPdK8mhC5mixf5seJGWDu/sQHuhdfiYZfvJCwqt7zSRwYPGBBW2QYt
PNde+T4DsNd6RtJfNCPclgpCT0Ob/C5rq4HVMJ10tCe+5SSULNO1dd81f5wVRfN+
UeAmeUtwWnNRxkEdNIgo902ZZQmpFASnRrMpkSmgEgKgycOmM/QDxNK1E1QU+L2a
84Ue8F5sIq4+IBQ2IzTy1xrvY1CcNP+4FB4MkVMvASEDPKNZvGkungaPytX5GJYi
1mL5qpn7Mt3tbjY+XoDQ98ZGOa0E7btb+hQ9FUNveMr2zpumH9lTEXSnBhACy+NU
qV9SLeUnUYPbxqjlYvLxa9zSBTKlB+iPtrzOTTuzgq9xdjvOOZ+3793Il5ETF5Ct
m2I46iXqQFKBGwrBN97d11oUSgj+0a5vrawayyHpkvQEbh6slOFg+ySmaJpEGR1x
SyMI3jTdYRrXiwePzc0HN22TJr6cd+nxcUqYQAPOUJe5ZaNrjYONlOkcTMpi0AhQ
p8cHhLwVHjjF0pXPPZ1w
=wA9J
-----END PGP SIGNATURE-----

--=-Y8OZb/S4Fi+UrSSdItRd--

