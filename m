Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:39154 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1HXMVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 08:21:52 -0400
Message-ID: <4E54ECDF.9030804@01019freenet.de> (sfid-20110824_142155_744452_9226528D)
Date: Wed, 24 Aug 2011 14:21:51 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [compat-wireless-3.1-rc1-1] rt2800usb crashes the machine
References: <4E536DD8.6030308@01019freenet.de> <20110824090340.GA2277@redhat.com>
In-Reply-To: <20110824090340.GA2277@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka schrieb:
> On Tue, Aug 23, 2011 at 11:07:36AM +0200, Andreas Hartmann wrote:
>> using rt2800usb with a Linksys WUSB600N v2 (rt3572) crashes the complete
>> machine (SMP, Core i5, linux 3.0) on unloading the module after using it
>> for a short period of time:
>> - 2 times netperf -t TCP_MAERTS -H host
>> - 2 times netperf -t TCP_STREAM -H host
>>
>> The error message in /var/log/messages is:
>>
>> phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting
>>
>> After the crash, you have to hard reset the machine.

[...]

> Otherwise perhaps you could photo crash logs on virtual terminal
> (switched by Alt+Ctrl+F2 from X-window) or by using netconsole or kdump.

There is no crash dump - the machine just hangs up itself and the fan is
getting loader and loader (until max), because the machine is getting
hot more and more.


Kind regards,
Andreas
