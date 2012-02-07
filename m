Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:38686 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab2BGHhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 02:37:18 -0500
Message-ID: <4F30D3EE.2010501@01019freenet.de> (sfid-20120207_083745_628042_60C4158A)
Date: Tue, 07 Feb 2012 08:34:06 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: trencan@centrum.cz, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: connection interrupted for rt61pci in master mode
References: <20120128154544.70E060CD@centrum.cz> <4F30BEED.4010905@01019freenet.de> <20120207071444.8C823024@centrum.cz>
In-Reply-To: <20120207071444.8C823024@centrum.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut,

could it be potentially a problem with smp or does the fix you provided
for rt2860 based wlan devices applies too for rt61pci?

I'm thinking about that, because I saw the same problems here some time
ago. And probably I can see it too with rt2800usb [1].


@Michal:
Just to verify (or falsify) this hypothesis: Could you please reboot the
machine with the additional kernel option maxcpus=0 (you can enter it in
the grub console) to just use cpu 0 (please verify with "cat
/proc/cpuinfo"). If the problem disappears, it's most probably smp related.

Another question: you didn't activate 802.11n. Is this correct?


Regards,
Andreas

trencan@centrum.cz schrieb:
> 
> Machine has "Intel Core i5-2500K" with 4 cores without Hyper-Threading.
> 
> Regards.
> Michal


Regards,
Andreas


[1]
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-February/004556.html
