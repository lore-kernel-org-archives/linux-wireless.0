Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48736 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbYBPQif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 11:38:35 -0500
Message-ID: <47B71171.6040805@hauke-m.de> (sfid-20080216_163902_820241_FD2C42FD)
Date: Sat, 16 Feb 2008 17:38:09 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>, andreamrl@tiscali.it
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Kernel panic after insmodding rtl8187
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC6BD3B3F3920040A766EB0F5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC6BD3B3F3920040A766EB0F5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

With the newest version of rtl8187 (out of compat-wireless) I get a
kernel panic after insmodding it.

I can't read the full error message, but the last lines  are looking
like this.

Loading the driver without having an realtek wireless device at the PC
is working normal.

I am using kernel 2.6.24 on Ubuntu AMD64 the rtl8187 chip is on an Asus
P5D Deluxe Wifi board.

I had the same kernel panic with wireless-2.6 everything from ~8.2.2008.

If you need more information please tell me what to do.

[<ffffffff8040a34f>] __qdisc_run+0x15f/0x200
[<ffffffff803fc02e>] dev_queue_xmit+0x20e/0x330
[<ffffffff88df54d9>] :mac80211:ieee80211_sta_scan_work+0x119/0x200
[<ffffffff88df53c0>] :mac80211:ieee80211_sta_scan_work+0x0/0x200
[<ffffffff8024c9df>] run_workqueue+0x7f/0x110
[<ffffffff8024d580>] worker_thread+0x0/0x130
[<ffffffff8024d645>] worker_thread+0xc5/0x130
[<ffffffff802510e0>] autoremove_wake_function+0x0/0x30
[<ffffffff8024d580>] worker_thread+0x0/0x130
[<ffffffff8024d580>] worker_thread+0x0/0x130
=2E...

Code: 0f b7 40 06 89 cb 80 cf 80 c1 e0 13 09 c3 49 8b 46 08 0f b7
RIP [<ffffffff88e28255>] :rtl8187:rtl8187_tx+0x55/0x1e0
RSP [<ffff81014333fc80>]
CR2 0000000000000006

Kernel panic - not syncing: Aiee, killing interrupt handler!
--=20
Mit freundlichen Gr=C3=BC=C3=9Fen

Hauke Mehrtens


Hauke Mehrtens
Westpreu=C3=9Fenweg 10
27442 Gnarrenburg
Tel.  : 04763/1745
Mobil : 0151/10778862
ICQ   : 160871207
Web   : www.hauke-m.de



--------------enigC6BD3B3F3920040A766EB0F5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBR7cRdYZ0px9YPRMyAQI4Pg/+OkupyynPl4yVOMrOSwvDIAAZvh5amqK5
1rOHa/E3XI8UyFZRiD5Vaw1b5PUArLZdstoNNnZGvFCM3VLzFG11SLFipGFoQ18N
P8DEJkIeSG1EZ/Sh3cQ4mX3oDAznstW4K6V8FHqTTsNb82XlIre0YBgf1rAxs2FY
Ey5jABgs7W1zRjoHAAt3T3aq/yXlmp3/axDZT3LFSGmQIdlC7koX1vzQ3+p7X0Ys
spkv7gRNTnyyyqvivRzr2LC19f5xa4D5PVYO5+v8/BWCS7XfgV+g28a/iQjamcsa
9+27oVVMK4Xwx0L6qv+niQ8erkOYDt9tP7eY53MZpdHwpun/Horm2N/jZm1FoOmh
59zsY2byuS7BPAV/YphK/PPTxuhrmPktSNWT2f17m4CG4rS5O2PExUCDelk2kNmr
CbfukTyA8bErToTX8S2syL+2A3UIP2aB+Qae1BT/3rJQfwtCaixpAqkN4jPnzOPl
D5RxrGNG0uYPslXjTQbG82BQtfZll+jXAqg5iNy/mF8O25APoaKDxB1eUdJFdn5K
uFqtcxIxVghZJtqzmXViZGGh/8owbARVsKo82Ej2tcUkm7n6G9xp24iCLrmAYhMF
WnCvVIBJ79w/yzGOXDiVE8G/vkIf5F4w1NaVMaJIbP8xw8cbMZZ/zbsRyjrAZJbS
6+33mnbXnDg=
=ElvS
-----END PGP SIGNATURE-----

--------------enigC6BD3B3F3920040A766EB0F5--
