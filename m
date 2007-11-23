Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:45767 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXKWFDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 00:03:16 -0500
Message-ID: <58948.84.58.144.191.1195794193.squirrel@webmail.madwifi.org> (sfid-20071123_050323_075064_4C82813A)
In-Reply-To: <40f31dec0711221538i503119b7hdeffbbde50629a6c@mail.gmail.com>
References: <200711222310.01165.virec@inmail.sk>
    <40f31dec0711221538i503119b7hdeffbbde50629a6c@mail.gmail.com>
Date: Fri, 23 Nov 2007 06:03:13 +0100 (CET)
Subject: Re: AR5006X on Fijitsu-Siemens Lifebook E8410 - not work
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "Majo" <virec@inmail.sk>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

>> 14:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG
>> 802.11 b/g Wireless PCI Express Adapter (rev 01)
> This is a 2424 pci-express card, we don't support this chip yet ;-(

Don't be fooled by the PCI ID - we already know that these are not
reliable to identify the chipset used on a Atheros-based card. See also
http://madwifi.org/ticket/1192.

I'd suggest Majo to use ath_info from MadWifi trunk, hopefully it allows
to recognize the chipset more reliably in his case, too. The ticket
mentioned above also has some instructions on how to use this tool.

> (the testbed stuff would really help)

Working on it, but it's still a long road. Getting non-profit status is
just the first step for that, and that's work in progress.

Bye, Mike
