Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:53386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbXLVWpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 17:45:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?=
	<ariveira@gmail.com>
Subject: Re: rt2x00 is sapmming my logs
Date: Sun, 23 Dec 2007 00:04:42 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20071222173153.42f574fd@Varda>
In-Reply-To: <20071222173153.42f574fd@Varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200712230004.42957.rjw@sisk.pl> (sfid-20071222_224529_625947_71ED16F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 22 of December 2007, Alejandro Riveira Fern=E1ndez wrote:
>=20
>  I have a rt2500pci card on an 64 bit system (Ubuntu) AMD X2 processo=
r and i'm
> trying latest vanilla kernels i've used a 2.6.24-rc5 kernel without m=
ayor issues
> (except that i have to issue a sudo iwconfig wlan0 rate 54M because i=
t allways
> connect at 1Mbit and it is dog slow) but now with v2.6.24-rc6-83-g5b8=
25ed i
> have my dmesg spammed with:
>=20
>=20
> [ 1122.323489] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.323491] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.326139] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.326142] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.327508] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.327511] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.329405] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.329409] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.332519] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.332522] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.334444] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.334447] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.336847] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.336850] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.338654] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.338657] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.340844] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.340847] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.343035] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.343038] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.344301] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.344303] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.347146] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
> [ 1122.347148] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [ 1122.349381] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 0.
>=20
>  The connection seems top work anyways so i do not think this is crit=
ical.
>  Thanks in advance for your time.

I have created a bugzilla entry for this problem at:
http://bugzilla.kernel.org/show_bug.cgi?id=3D9622
and added it to the list of reported regressions.

Thanks,
Rafael
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
