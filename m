Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXFTLRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:17:47 -0400
Subject: ieee80211_set_aid_for_sta?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hkBToRVUG3Pk/rT03ioV"
Date: Wed, 20 Jun 2007 01:39:30 +0200
Message-Id: <1182296370.3714.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hkBToRVUG3Pk/rT03ioV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

As with the radar stuff, I don't see any users of
ieee80211_set_aid_for_sta. It seems to be useful when firmware
establishes sta MAC->AID mapping, but hostapd doesn't handle that
currently. Remove until we find new hardware requiring it?

johannes

--=-hkBToRVUG3Pk/rT03ioV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGeGky/ETPhpq3jKURAhIOAJ9+vdELomMmRGXxb2kBoxoTqNj2JACeLjBw
LPADznjZyUwi8HmwHLLC3rQ=
=E38z
-----END PGP SIGNATURE-----

--=-hkBToRVUG3Pk/rT03ioV--

