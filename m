Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:11393 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbYARL2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 06:28:50 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1005876fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2008 03:28:48 -0800 (PST)
Date: Fri, 18 Jan 2008 12:26:23 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?=
	<ariveira@gmail.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, IvDoorn@gmail.com
Subject: Re: Spammed logs again rt2500pci 2.6.24-rc8
Message-ID: <20080118122623.3561b3ed@Varda> (sfid-20080118_112857_178596_4DB7D2DB)
In-Reply-To: <1200653765.7492.10.camel@localhost>
References: <20080117225744.29aa214c@Varda>
	<1200653765.7492.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El Fri, 18 Jan 2008 11:56:05 +0100
Mattias Nissler <mattias.nissler@gmx.de> escribi=C3=B3:

> Hi,
>=20
> we currently think this is due to a race condition in the packet queu=
e
> code. Ivo is currently reworking the packet queues, which I hope will
> resolve this situation.

 Thanks for the quick answer.=20

>=20
> Mattias

 Regards;
 Alejandro

>=20
> On Thu, 2008-01-17 at 22:57 +0100, Alejandro Riveira Fern=C3=A1ndez w=
rote:
> > Running
> >=20
> > Linux Varda 2.6.24-rc8 #1 SMP PREEMPT Wed Jan 16 15:09:43 CET 2008 =
x86_64 GNU/Linux
> >=20
> > my logs are spmmed with:
> >=20
> >=20
> > [20126.343240] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at =
non-free entry in the non-full queue 1.
> > [20126.343242] Please file bug report to http://rt2x00.serialmonkey=
=2Ecom.
> > [20126.848277] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at =
non-free entry in the non-full queue 1.
>
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
