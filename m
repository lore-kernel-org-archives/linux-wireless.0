Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760706AbYFHLyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 07:54:19 -0400
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054
	usb	adapter
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Couckuyt <iv0co@yahoo.co.uk>
Cc: linux-wireless@vger.kernel.org, Chr <chunkeey@web.de>
In-Reply-To: <4849A6D4.2090904@yahoo.co.uk>
References: <47AF79DA.10204@yahoo.co.uk>
	 (sfid-20080220_180121_070641_4FFC2208) <1203532811.17534.79.camel@johannes.berg>
	 <4849A6D4.2090904@yahoo.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1Bkqo+ASfJ3ISFv+FIk0"
Date: Sun, 08 Jun 2008 13:54:14 +0200
Message-Id: <1212926054.698.36.camel@johannes.berg> (sfid-20080608_135422_997802_B3DB100D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1Bkqo+ASfJ3ISFv+FIk0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-06 at 23:06 +0200, Ivo Couckuyt wrote:
> Sorry for the late reply, i just thought i install kernel 2.6.25 r4 and=20
> try again.
>=20
> It is somewhat better and worse, when modprobing p54usb i got a small=20
> hang/hickup accompanied with the following error in dmesg
> ehci_hcd 0000:00:02.2: HC died; cleaning up
>=20
> afterwards the kernel fails (refuses ?) to detect the device again. so I=20
> no longer get a kernel oops but even modprobbing doesnt work anymore.
> see attachment for full dmesg. any ideas, testing i an do now ?
>=20
> kind regards,
> Ivo Couckuyt
>=20
> Johannes Berg wrote:
> >> I followed the guidelines for a bug report.
> >> If there is anything else needed, I'll be happy to do all the testing=20
> >> needed.
> >>
> >> [1.] One line summary of the problem:
> >> p54usb driver crashes on trying to associate with an ap with the=20
> >> CPWUA054 usb adapter
> >>
> >> [2.] Full description of the problem/report:
> >> What works:
> >> modprobe p54usb
> >> dmesg (displays my adapter correctly)
> >> ifconfig up wlan0
> >> dmesg (using the right firmware 2.5.6.0)
> >>
> >> but trying to associate to my accesspoint (using wpa_supplicant) cause=
s=20
> >> a hard-lock up (keyboard leds blinking).
> >> Before locking up it spams loads of 'RX: unknown frame received phy1'=20
> >> messages on kmsg/dmesg.
> >>    =20
> >
> > Please switch to a VT (e.g. VT 1, usually by pressing ctrl-alt-f1) and
> > associate by hand (e.g. iwconfig wlan0 essid "your ssid") and take a
> > picture of the oops that comes out.
> >
> > johannes
> >  =20
> plain text document attachment (2.6.25_irq)
> usb 1-1: new high speed USB device using ehci_hcd and address 4
> usb 1-1: configuration #1 chosen from 1 choice
> p54: LM86 firmware
> p54: FW rev 2.5.6.0 - Softmac protocol 3.0
> ehci_hcd 0000:00:02.2: HC died; cleaning up
> irq 11: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Not tainted 2.6.25-gentoo-r4-BARTON #1
>  [<c0149ee7>] __report_bad_irq+0x27/0x90
>  [<c014a218>] note_interrupt+0x2c8/0x300
>  [<c01493e1>] ? handle_IRQ_event+0x31/0x70
>  [<c014aced>] handle_level_irq+0xdd/0x110
>  [<c0105e26>] do_IRQ+0x46/0x80
>  [<c010415f>] common_interrupt+0x23/0x28
>  [<c01493c7>] ? handle_IRQ_event+0x17/0x70
>  [<c014ac8a>] handle_level_irq+0x7a/0x110
>  [<c0105e26>] do_IRQ+0x46/0x80
>  [<c010415f>] common_interrupt+0x23/0x28
>  [<c0120e92>] ? __do_softirq+0x42/0xb0
>  [<c0120f35>] do_softirq+0x35/0x40
>  [<c01210f4>] irq_exit+0x44/0x50
>  [<c0105e2b>] do_IRQ+0x4b/0x80
>  [<c010415f>] common_interrupt+0x23/0x28
>  [<c0102b9d>] ? default_idle+0x4d/0x80
>  [<c0102b50>] ? default_idle+0x0/0x80
>  [<c0102af3>] cpu_idle+0x33/0x90
>  [<c03caadc>] rest_init+0x5c/0x60

Sorry, no idea. Christian?

johannes

--=-1Bkqo+ASfJ3ISFv+FIk0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIS8hiAAoJEKVg1VMiehFYYWIQALRVDtr6pJ3HQ9TUv88J9Cgj
Fo2uBTLg1z6BcfjONKZomIMr4Pz382YrJ7Rp6MIkvlXfbdosqjRCHld5AcLXTnUJ
Fx1RqPeZSkhDArKRsJ0I2yBQ8qAld5EmFnqFs6pFRbgPlKzBllzj0cLqsK4HlHlz
dVU4qCTLy9Hek2H2e2UCcPikJuAj0qpFZVe4Bbyj7eghO0Jw2Q1kel0t4jOh9Pox
k5cH/W276kpdSxRovzAFdDk3ebigQrpDPvuxS7ssI6UZ//XY2k08DsHFoA+2nwZ6
mJkoG9qaubLs4J3WNqcW7kuGwp5GVLQ9AaelmZavFYm4bi97+m9ZYo4RBza4ap2p
0pYdaDLAsv+lEakmTH4/S0ehnM+pQIxq/iRUguTwkYmHu/JWFZAAVrsD2LGWr71E
rvlIrIV7f4pIDq8xsRYKrn0hQjAlh1XYb4gL0PWb4p0RaHVbPtctbgviOpyyGaTx
dDJHiIbPVXyU6KKx9fA4+P/iqL6BMYSv9xqSc/sNLAm7+BQwcHGtK0PCc0oT7rp8
05ykQN337eCUuU8bEp1jWk3d5t7P0Lw3233yBgZQaX1VROLZq+1OUdFaD+I3k9a9
EBWGqi59pqYB9sOb+OMMJUNtoaDMV0fXXoqu9g2crsQM5XeRSC4fQlmJCpZGhqXW
gZm55bpha220dgMgoPM/
=LKET
-----END PGP SIGNATURE-----

--=-1Bkqo+ASfJ3ISFv+FIk0--

