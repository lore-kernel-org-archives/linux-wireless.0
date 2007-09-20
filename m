Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXITNuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:50:18 -0400
Subject: generic IE and AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GNSfXD2gKbOKLKn2VwA5"
Date: Thu, 20 Sep 2007 03:58:46 +0200
Message-Id: <1190253526.18521.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GNSfXD2gKbOKLKn2VwA5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Currently we have some sort of support for hardware that generates
beacons independently. However, we have no such hardware. Hostapd,
however, requires that SIOCSIWGENIE doesn't fail. I suppose it can be
taught to ignore it.

However, the question is whether we want to support such hardware
designs in mac80211. I tend to not want to with the ever increasing
complexity and number of fields in the beacon. Where should the "generic
element" be inserted into the beacon? Last? After the TIM? Then how does
the hardware know what to include in the supported rates element etc?

Does anyone object to just getting rid of it?

johannes

--=-GNSfXD2gKbOKLKn2VwA5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8dPW/ETPhpq3jKURAvdEAJ4of3pL582Vku0BiLevp0VX+jZ0wQCgrcIB
x/eRLUPT04xmPvtsVCYpHYo=
=FfyX
-----END PGP SIGNATURE-----

--=-GNSfXD2gKbOKLKn2VwA5--

