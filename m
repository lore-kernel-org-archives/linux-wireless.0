Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYLALJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:09:53 -0500
Subject: 11d segfault
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MMU9oV15nk4WVEJAsrRD"
Date: Mon, 01 Dec 2008 12:09:02 +0100
Message-Id: <1228129742.3478.2.camel@johannes.berg> (sfid-20081201_120955_727401_027AF42F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MMU9oV15nk4WVEJAsrRD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dec  1 12:07:00 johannes kernel: [  193.370168] Unable to handle kernel pag=
ing request for data at address 0x00000000
Dec  1 12:07:00 johannes kernel: [  193.370180] Faulting instruction addres=
s: 0xf2794560
Dec  1 12:07:00 johannes kernel: [  193.370194] Oops: Kernel access of bad =
area, sig: 11 [#1]
Dec  1 12:07:00 johannes kernel: [  193.370196] PREEMPT PowerMac
Dec  1 12:07:00 johannes kernel: [  193.370200] Modules linked in: ...
Dec  1 12:07:00 johannes kernel: [  193.370266] NIP: f2794560 LR: f27944fc =
CTR: 00000000
Dec  1 12:07:00 johannes kernel: [  193.370270] REGS: eed15ce0 TRAP: 0300  =
 Not tainted  (2.6.28-rc6-wl-dirty)
Dec  1 12:07:00 johannes kernel: [  193.370273] MSR: 00009032 <EE,ME,IR,DR>=
  CR: 22000048  XER: 20000000
Dec  1 12:07:00 johannes kernel: [  193.370283] DAR: 00000000, DSISR: 40000=
000
Dec  1 12:07:00 johannes kernel: [  193.370286] TASK =3D ef145640[1049] 'ph=
y0' THREAD: eed14000
Dec  1 12:07:00 johannes kernel: [  193.370289] GPR00: 00000000 eed15d90 ef=
145640 eed15d38 22222222 00000000 eed15d48 37d38608=20
Dec  1 12:07:00 johannes kernel: [  193.370299] GPR08: 37d38600 00000000 c0=
3f97e0 f279bda0 82000044 00000000 00000000 00000000=20
Dec  1 12:07:00 johannes kernel: [  193.370309] GPR16: 00000000 41400000 01=
400000 017f4bb4 017f42c0 00000000 c03f9400 c04264e8=20
Dec  1 12:07:00 johannes kernel: [  193.370319] GPR24: c03f9438 00000000 f2=
79c410 eecaa080 f279bd8c f27a0000 ec44a0d6 00000006=20
Dec  1 12:07:00 johannes kernel: [  193.370346] NIP [f2794560] regulatory_h=
int_11d+0x98/0x14c [cfg80211]
Dec  1 12:07:00 johannes kernel: [  193.370352] LR [f27944fc] regulatory_hi=
nt_11d+0x34/0x14c [cfg80211]
Dec  1 12:07:00 johannes kernel: [  193.370355] Call Trace:
Dec  1 12:07:00 johannes kernel: [  193.370361] [eed15d90] [f27944fc] regul=
atory_hint_11d+0x34/0x14c [cfg80211] (unreliable)
Dec  1 12:07:00 johannes kernel: [  193.370418] [eed15dd0] [f27f7adc] ieee8=
0211_rx_mgmt_beacon+0x1a8/0x1ec [mac80211]
Dec  1 12:07:00 johannes kernel: [  193.370432] [eed15e80] [f27f86f4] ieee8=
0211_sta_rx_queued_mgmt+0x150/0x344 [mac80211]
Dec  1 12:07:00 johannes kernel: [  193.370446] [eed15f40] [f27f8970] ieee8=
0211_sta_work+0x88/0x260 [mac80211]
Dec  1 12:07:00 johannes kernel: [  193.370455] [eed15f60] [c0047120] run_w=
orkqueue+0xc0/0x164
Dec  1 12:07:00 johannes kernel: [  193.370460] [eed15f90] [c0047544] worke=
r_thread+0xb0/0x134
Dec  1 12:07:00 johannes kernel: [  193.370468] [eed15fd0] [c004bb24] kthre=
ad+0x50/0x88
Dec  1 12:07:00 johannes kernel: [  193.370473] [eed15ff0] [c0013cf4] kerne=
l_thread+0x4c/0x68
Dec  1 12:07:00 johannes kernel: [  193.370476] Instruction dump:
Dec  1 12:07:00 johannes kernel: [  193.370481] 38210040 7c0803a6 4e800020 =
881e0002 3b200001 2f800049 419e0014 6800004f=20
Dec  1 12:07:00 johannes kernel: [  193.370493] 7c000034 5400d97e 5419083c =
813dc410 <80090000> 2f800000 409effb8 7fc3f378=20
Dec  1 12:07:00 johannes kernel: [  193.374781] ---[ end trace d7369ca97f59=
3d84 ]---


--=-MMU9oV15nk4WVEJAsrRD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJM8XKAAoJEKVg1VMiehFYzTAQALWVxrqf9BKorEpDsyT2PRzc
50eEzD7naJyPUn5RFEgFP1KzL+jT2ocQtBHIrvAmkI80jfE1G3k7kc78CAEHv+L5
xirGp6pQ0kk5PUmUYDzhFoXhdLSRwy/rIrSD8RVGfSudtduCJHweAD2FooXrdUyB
eo/kLyH8mTTK5m1m+823SgvlT8uZJH+M2w2oYkLOKoTnK058+isjSgRG1zntagAO
G22S0KoJIb5Xywx/N1EGXaQX1F6Hb6kTrI4HiLmCsA29ve2QZ2ThOVJHlNIGC5OZ
x8Tm3IAHJPsaucMGLIW3H2ynru6FlHfFcFe5W42RSfzgzc71PkTRVhI5G8kWm9Lu
LcK5977zWNbzUiyUIIJY/KCi5i+75hPK80jmGf2p8oBpgI9Db2oKm9sd4UUeU64P
W5P3OvjkwDuh544MXneR9s1TJd1BpwF7o7fVTxv11ie+C1Coo+KftQWTezlN7W1t
HLyTnZlSeWc/bVDKJyV+PE2GuxX5Kd7sfmJQ27md23FWBVu3DP1jV7ScQ0NKSZ78
NeRGgHfUg7HzUcU/D4SwAYtPR9Zsbq1HGjKOCDa+Q+SVwZzIGNQCYeBrwmpDim9+
sjApT+yuLdOwc1RIHoxTiF+qJvy9jZJdkkS6pL4Mkdj7nx4EUN2fVNIdRghRltU+
DJxfVPyK6mAxy47E+2sI
=tJxe
-----END PGP SIGNATURE-----

--=-MMU9oV15nk4WVEJAsrRD--

