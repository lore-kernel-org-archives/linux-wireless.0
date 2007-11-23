Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:43443 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbXKWKYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 05:24:22 -0500
Received: by an-out-0708.google.com with SMTP id d31so639048and
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 02:24:21 -0800 (PST)
Message-ID: <40f31dec0711230224h2301d52fl75db75fff4a88818@mail.gmail.com> (sfid-20071123_102431_256391_125B2985)
Date: Fri, 23 Nov 2007 12:24:20 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Michael Renzmann" <mrenzmann@madwifi.org>
Subject: Re: AR5006X on Fijitsu-Siemens Lifebook E8410 - not work
Cc: Majo <virec@inmail.sk>, linux-wireless@vger.kernel.org
In-Reply-To: <58948.84.58.144.191.1195794193.squirrel@webmail.madwifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200711222310.01165.virec@inmail.sk>
	 <40f31dec0711221538i503119b7hdeffbbde50629a6c@mail.gmail.com>
	 <58948.84.58.144.191.1195794193.squirrel@webmail.madwifi.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm you might be right about this, ath_info would really help. Problem
is we din't have such reports about nic_wakeup before, not even on
2425 (AR5007EG). In all cases (except 5416/5418) at least attach
worked ! In this case attach doesn't work at all ;-(

This might be the new 2417 chip (AR5007G), if they had faulty pci id
for 5007EG they might have done the same for 5007G (but 2417 is not
pci-express !).

Majo can you plz do what Mike said and give us a dump of ath_info tool ?

Thanx in advance...

2007/11/23, Michael Renzmann <mrenzmann@madwifi.org>:
> Hi.
>
> >> 14:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG
> >> 802.11 b/g Wireless PCI Express Adapter (rev 01)
> > This is a 2424 pci-express card, we don't support this chip yet ;-(
>
> Don't be fooled by the PCI ID - we already know that these are not
> reliable to identify the chipset used on a Atheros-based card. See also
> http://madwifi.org/ticket/1192.
>
> I'd suggest Majo to use ath_info from MadWifi trunk, hopefully it allows
> to recognize the chipset more reliably in his case, too. The ticket
> mentioned above also has some instructions on how to use this tool.
>
> > (the testbed stuff would really help)
>
> Working on it, but it's still a long road. Getting non-profit status is
> just the first step for that, and that's work in progress.
>
> Bye, Mike
>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
