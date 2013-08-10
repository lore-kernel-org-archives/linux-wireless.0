Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:39692 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650Ab3HJRyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 13:54:00 -0400
Date: Sat, 10 Aug 2013 19:53:35 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: rt2800usb: Kernel log spammed with TX status messages
Message-ID: <20130810195335.2903d0c2@marge> (sfid-20130810_195404_534906_8B67E28A)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VvpGkiCigMIho.652Q708j="; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/VvpGkiCigMIho.652Q708j=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

My kernel logs are spammed with messages like the ones below.
I'm currently running latest debian sid kernel, which is based on 3.10.5.
The device is
Bus 009 Device 002: ID 148f:5370 Ralink Technology, Corp. RT5370 Wireless A=
dapter

Any idea on how to debug/fix this?

Aug 10 11:27:44 marge kernel: [ 5560.310989] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.311077] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.311101] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.319229] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 12 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.319271] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 12 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.319281] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 12 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.319305] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 13 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.330987] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 14 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.331107] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 14 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.331126] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 14 in queue 2
Aug 10 11:27:44 marge kernel: [ 5560.412247] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:44 marge kernel: [ 5560.412364] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:44 marge kernel: [ 5560.412488] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:44 marge kernel: [ 5560.412612] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5560.923400] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 0 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.923421] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 0 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.923424] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 0 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.927149] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 1 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.927166] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 1 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.927169] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 1 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.943279] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 2 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.943301] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 2 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.943310] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 2 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.943332] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 3 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.947404] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 4 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.947432] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 4 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.947436] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 4 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.947445] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 5 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.971166] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 6 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.971215] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 6 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.971224] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 6 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.971254] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 7 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.971264] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 8 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.979413] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 9 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.979448] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 9 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.979456] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 9 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.979476] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 10 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.987291] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.987339] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.987347] ieee80211 phy0: rt2800usb_entr=
y_txstatus_timeout: Warning - TX status timeout for entry 11 in queue 2
Aug 10 11:27:45 marge kernel: [ 5560.996550] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5560.996667] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.069806] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.069925] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.070048] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.070173] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.070298] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.070423] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.070547] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.070675] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.070798] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping
Aug 10 11:27:45 marge kernel: [ 5561.087058] ieee80211 phy0: rt2800usb_txdo=
ne: Warning - Got TX status for an empty queue 2, dropping

--Sig_/VvpGkiCigMIho.652Q708j=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBn4fAAoJEPUyvh2QjYsOwOgQAMuco6nlE2afv7DPWpIr/Gxj
7EpNFN8qLsNomR5tMIydvnx/+0k5HO9wawSNCt6jNHvV0LxQQXCGpt8WBmSIE/cr
m/sEC7HVVmyOb9EzcFXkhIUUtA7iihNuQwOjSOsa1+JhOghNudVW8FwaE937Hr29
EzAC+bKtGHXzJFUlFFfJNh7kWV6BYjt7sy6Yjl28xeHmkMtvEPmD1OkUQfm+rMK+
u//MV9e8lvDQgjUj8DkBSdLs1IwHSHne00OaDhGoxa88mFBbvyw+U0KXExXLe5vP
yIiQasuRc9CK3XGXPno4LLpN6JITFinsD/sOUGRyjMP5y2bfgQrt5gRE/XreuUTs
xnRlkK5V8CxnhqQRKY5ts+qRZgJxiQfAMz6XrZwe/qXUIsVwXtk/93OWaefJCtvq
gOh1UXgR0B4kTeZ8S86NIuMM3zj0ETbabjB1g4akiojPu0UNaeVsuYGhk7NdCGOg
SZ54bCVcuaoaiiEDPlJ69lE9gpyaqeKcOeESvw+uRXUYGEI/0t4Vlo1TocaBWEEM
6To5khu4m5YJHbjbWoSrMM+o/gaqqR/qIaHMiHO+JSSGIvDRWjUTHJK/aSO4l1lt
KvGk6OJDltkHgxJYIWMUi2FVCu1r34oweRYA+pjSklRDPvvJaQA68KCMlUistuNK
wbQTng79Su7YVH6G17on
=Z3k4
-----END PGP SIGNATURE-----

--Sig_/VvpGkiCigMIho.652Q708j=--
