Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXFTLQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:16:46 -0400
Subject: ieee80211_radar_status?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bRALrzPAzw5RVDnRrQAO"
Date: Wed, 20 Jun 2007 01:36:21 +0200
Message-Id: <1182296182.3714.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bRALrzPAzw5RVDnRrQAO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Is there any documentation for the arguments to ieee80211_radar_status?
I don't see anything in the header files and drivers nor any use in
wpa_supplicant and hostapd.

When moving to nl80211, this shall be handled there, but since we don't
have anybody using it right now we might as well kill it off completely
until we need it (again).

johannes

--=-bRALrzPAzw5RVDnRrQAO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGeGh1/ETPhpq3jKURAjw3AJ4lHs83JecOYjI+Siyh/hOuOCPu5gCfUolr
7J3tlcZl0w1lTLAt2HTDlJ8=
=Ds1H
-----END PGP SIGNATURE-----

--=-bRALrzPAzw5RVDnRrQAO--

