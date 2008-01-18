Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37486 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755584AbYARK4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 05:56:09 -0500
Subject: Re: Spammed logs again rt2500pci 2.6.24-rc8
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?=
	<ariveira@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, IvDoorn@gmail.com
In-Reply-To: <20080117225744.29aa214c@Varda>
References: <20080117225744.29aa214c@Varda>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 18 Jan 2008 11:56:05 +0100
Message-Id: <1200653765.7492.10.camel@localhost> (sfid-20080118_105619_195599_D599CEBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we currently think this is due to a race condition in the packet queue
code. Ivo is currently reworking the packet queues, which I hope will
resolve this situation.

Mattias

On Thu, 2008-01-17 at 22:57 +0100, Alejandro Riveira Fern=E1ndez wrote:
> Running
>=20
> Linux Varda 2.6.24-rc8 #1 SMP PREEMPT Wed Jan 16 15:09:43 CET 2008 x8=
6_64 GNU/Linux
>=20
> my logs are spmmed with:
>=20
>=20
> [20126.343240] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20126.343242] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20126.848277] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20126.848280] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20126.851693] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20126.851696] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20126.851854] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20126.851856] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20126.852082] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20126.852084] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20126.852224] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20126.852226] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20127.349691] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20127.349694] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20127.352425] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20127.352428] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20127.853345] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20127.853348] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20127.853699] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20127.853701] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20128.858569] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20128.858572] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20131.875550] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20131.875554] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20154.693853] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20154.693856] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20185.527974] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20185.527977] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20189.812334] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20189.812337] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20189.812374] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20189.812376] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20189.812507] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20189.812509] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20189.813100] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20189.813102] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20189.813474] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20189.813476] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20189.813909] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20189.813911] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20212.242858] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20212.242861] Please file bug report to http://rt2x00.serialmonkey.c=
om.
> [20212.243587] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at no=
n-free entry in the non-full queue 1.
> [20212.243589] Please file bug report to http://rt2x00.serialmonkey.c=
om.
>=20
>=20
> As the last time the thing is triggered with a p2p app making a lot o=
f connections (this time not bt but mldonkey)
> Back to top =09
> View user's profile Send private message =09
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
