Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762696AbYEESer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 14:34:47 -0400
Subject: Re: [RFC] mac80211: Don't encrypt beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805052036.07862.IvDoorn@gmail.com> (sfid-20080505_202834_583735_2C9067EC)
References: <200805051841.51408.IvDoorn@gmail.com>
	 <1210005414.8245.40.camel@johannes.berg>
	 <200805052036.07862.IvDoorn@gmail.com>
	 (sfid-20080505_202834_583735_2C9067EC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hD6sXcnpjl+sMIpimrxV"
Date: Mon, 05 May 2008 20:33:44 +0200
Message-Id: <1210012424.4181.9.camel@johannes.berg> (sfid-20080505_203439_811758_924DBB36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hD6sXcnpjl+sMIpimrxV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hmm, your absolutely right, I hadn't checked the wireless-testing code ye=
t. :)
> I only noticed this bug since a user had hostapd running on rt2x00.git wi=
th
> rt61pci HW crypto enabled.

:)

> I'll respin the patch to apply for wireless-testing ;)

Send it to John, I'll port it over to tx-info when it arrives in my
tree.

johannes

--=-hD6sXcnpjl+sMIpimrxV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB9TBqVg1VMiehFYAQJZGQ/7BvOGmJT7j/k23BtRK46/iknFDRl8Bfbw
j66UBYc47dWwX7mFZ98O1bb0iXYSB90j/KIsWdgH3ndoMxWtS1TjLau9Zmu1XuY3
ZMByVyj46zcHO50pnIMbSA2+tR1uLAaES001qDTYm/lAUp7UCisYbZZ6BU+XFFsF
VNDmGliLKlgFfc2W/CQCoVPaS6k5EfsHeo6vbyQXC9LDZ89V6TgaAjjdjbl8KwFy
c7poKTemwhaKGfRixt+oGsIDbgZF2+WcgOK0aAqiBqqQF/NFz6vAH/3qjT98FKFj
RRgFMXTu721vW9mya8bnmVXgiI7N4uVDnQPVuvzjLHr5u5LmN1rgWKo3N+iLgQgC
eQabmqjpZK8H488CaNaiVErm96ZnmBxKea/OSC9+hKoU77yTPk8mnw0iPJ4lSLpv
rgHIl1Fpo1sspobylmxB8bnSMZ+fzhOhqsE0kUjxU5e6c89dy6IP/wUOkplhP5kB
UXxHhM5MRQiiND3wfVDj4gfWhjvJXYbRf6EJa813FtA5+ZEQzrkFh2O4BVY9/38U
bSu7xCCtrlMaiaV8z5I8q5scnFcXMe921PT9yqu85FAHUTknVvlxZUddyx0EU6nq
XyMe0eOopxRQKWZ5miXk23p+gcojFVcIjKAUGHPuqzglTUtFkbmgS+AvO01ihrQL
f64CwmZXsA8=
=YmSv
-----END PGP SIGNATURE-----

--=-hD6sXcnpjl+sMIpimrxV--

