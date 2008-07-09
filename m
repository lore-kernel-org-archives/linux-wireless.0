Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYGIOuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 10:50:35 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091657.54657.IvDoorn@gmail.com> (sfid-20080709_164905_644218_D7086E89)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091604.50199.IvDoorn@gmail.com>
	 <1215611931.3246.8.camel@johannes.berg>
	 <200807091657.54657.IvDoorn@gmail.com>
	 (sfid-20080709_164905_644218_D7086E89)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LMLaPaDfuoRfIg68D07o"
Date: Wed, 09 Jul 2008 16:49:46 +0200
Message-Id: <1215614986.3246.19.camel@johannes.berg> (sfid-20080709_165038_600404_83701837)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LMLaPaDfuoRfIg68D07o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 16:57 +0200, Ivo van Doorn wrote:

> > Well, if you care about the beacon in config_interface() you're
> > implementing hwseq since otherwise you'd only request it when you need
> > it, no?
>=20
> No not really, because from what moment can the driver start requesting b=
eacons?
> I would think when mac80211 calls config_interface with the IEEE80211_IFC=
C_BEACON
> flag. ;)
>=20
> At that moment the first beacon is loaded, and the device will trigger th=
e interrupt
> to request a new beacon every x milliseconds.

Ok, I'd have thought you just set the "please send beacons now" flag and
request one on the next round.

johannes

--=-LMLaPaDfuoRfIg68D07o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdNAGAAoJEKVg1VMiehFYIvsQAITjmNSpKLifp+oLY2IXS1dn
EdyNBXPDm6jV/zeejKgy8Txd5kKaXlU4JIXS6cqIV/BaY+qOxJukamSDFVFL+77p
m1nTSQV3sS7NB91DaO7NxUo6aE08DL1wyrFtz2U6k/16tgcUw9LUYrlpuUV5v3PP
SBO3wdWd1C1PhyJeS78k0wcUfiZtRmKUk5L6V50iTOV+tsukjGXY0FMu4HtT6ty3
6VhhxIcl5u8YtlgeIoPaxKwMft2LE2E9wevJdwN3KXE0oXWl2AUhh2e/WbO90lA7
wMzDP2XyQuGOuFy6YCSee2WlcGcIFwz7216Zxu0nu9D+sKzzNB6v3Ds2nSRcReU3
Rsc6Cg6ZHZ5O/KoslJUox+GuiPzdjPlhDBKiKy2AdmmJgpD5XnGaqY6aWaJxhx2a
qCCSQaoidbi8yktIfYaPGHxvFWWiV840oVlC4d1qzf04bFkzPaUB38MyHQl7tnMt
ZOFXESz+SN3llUc5pRtSp+G4jVIZ5XRsDzNABocEhfnsfeJUAocm5YO/RGzoSrnL
sKs5sJkig3BpKmDlP5kwuiyolm+HvSkOOeFN0m2fYZeAL+l0ujI9jcm3HSnIjZ7D
uimX9k/y25H9Y1Hci45oPQvDSz7A3klz/APndz5IAgTg3EaUcIyoU4z5PEEEzU7i
48XOSn45OUQVanim1lan
=gIWv
-----END PGP SIGNATURE-----

--=-LMLaPaDfuoRfIg68D07o--

