Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbXKSOsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 09:48:50 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <Kalle.Valo@nokia.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20071118230237.GB8672@jm.kir.nu>
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605550.4793.93.camel@johannes.berg> <20071111025808.GK4031@jm.kir.nu>
	 <87pryfd8cc.fsf@nokia.com> <1194953217.9116.38.camel@johannes.berg>
	 <20071118230237.GB8672@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nNsroS6cvwX33XaaJRJI"
Date: Mon, 19 Nov 2007 15:50:07 +0100
Message-Id: <1195483807.8642.14.camel@johannes.berg> (sfid-20071119_144853_939270_CC7E815D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nNsroS6cvwX33XaaJRJI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2007-11-18 at 15:02 -0800, Jouni Malinen wrote:
> On Tue, Nov 13, 2007 at 12:26:57PM +0100, Johannes Berg wrote:
>=20
> > The N800 and similar devices only wake up at DTIM beacons, right? So
> > another idea would be to burst beacons but make sure the DTIM beacon
> > time doesn't fluctuate away from the DTIM TBTT. This would be possible
> > by changing the order of the beacons and adjusting the DTIM count so
> > that the beacon with DTIM count zero is always the first.
>=20
> This could be an improvement for small number of BSSes, but if the DTIM
> period starts going up, the delay in sending out multicast/broadcast
> frames may not be acceptable anymore depending on application.

Well even if you have a larger number of BSSes you can spread the DTIm 0
beacons across the periods so that you have a few but not all DTIM 0
beacons at one time. And that's still an improvement over currently used
schemes.

johannes

--=-nNsroS6cvwX33XaaJRJI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0GinaVg1VMiehFYAQKBSw//QHKdpyAQSwNy6oOgi6pHySsRgFezUI5t
Bg6MsfeLF34bUrpRoeNwWB5n2bVft4nyycYVY9ABocoLMd044WHVompWLXQ6OLx2
Av+XKUn3o1zs0WtWn+kkY+U8xtcoLtSPbvcqWftdKQDkdYpIXT4UN/evmeExUISS
oelqaAcOR/Gq90YNVm165vXLwOlWxFEcYh8eoa3dmcpP5pBqFrQAYmnn0VFKVxWX
MnP/Ve13NosNDTXEzPccUA+dP/AXzS/NlEf4Tph7s/DIM2nBww2wbhDmXiPCcusI
1S/vcXLbdqlyhDG/xKY0NPHv1KisF1HheDwi+Dnk1vhnPgUahLUzS+CZ+2eWWEeS
oPQ+42U3F72szpXChJzWNgWfmHpVmAgwUKEXLAcLWElBac8gTCqp8YAagQL3K5r/
nP/rmVixoH2AwUZvb+Wgjre4TPiNgjItc7OIctfsqXIfIQIqU6bLq/b+UHPSmR94
JzKBEOH0EvOv1CVTJ5qRGXv1xGquvzYZDlIwWLn1vWxJwK4iRjrg/Ilh17xQouwD
UgblswCyXCtuzoBrXKIiK/8wQ1acy/7xjGNjmsRghnM8rJS1yYuSv4CfOFLq1UZa
xsxe/NoU4IwdYOuC0ykc/mbmjcsL1IriLOOCHneU1G4Wco3xFqs9PqglUdzfDc+L
0sfmgmuX9Vw=
=XYq8
-----END PGP SIGNATURE-----

--=-nNsroS6cvwX33XaaJRJI--

