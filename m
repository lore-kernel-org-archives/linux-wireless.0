Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39181 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYAFHzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 02:55:38 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JBQLW-0007aU-Vf
	for linux-wireless@vger.kernel.org; Sun, 06 Jan 2008 07:55:02 +0000
Received: from cpc3-cwma2-0-0-cust15.swan.cable.ntl.com ([81.96.204.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 07:55:02 +0000
Received: from andy by cpc3-cwma2-0-0-cust15.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 07:55:02 +0000
To: linux-wireless@vger.kernel.org
From: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sun, 06 Jan 2008 07:49:08 +0000
Message-ID: <478087F4.7090500@andrewprice.me.uk> (sfid-20080106_075542_574197_8E26FB37)
References: <200712290942.37396.chris2553@googlemail.com> <200801020632.31361.chris2553@googlemail.com> <200801022002.29262.IvDoorn@gmail.com> <200801041709.12043.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: public-chris2553-gM/Ye1E23mwN+BqQ9rBEUg@ciao.gmane.org
In-Reply-To: <200801041709.12043.chris2553@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/08 17:09, Chris Clayton wrote:
> On Wednesday 02 January 2008, Ivo van Doorn wrote:
>> On Wednesday 02 January 2008, Chris Clayton wrote:
>>> Ah, does the patch I have applied and am running need enhancement,
>>> please?
>> ---
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
>> b/drivers/net/wireless/rt2x00/rt2x00dev.c index ff399f8..3c10a68 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> 
> <snip>

I was seeing the same warning so I've applied the patch to the latest
mainline git tree. It's cured the warning and everything seems to be ok
so far. I'll let you know if I see any side effects. In case you're
interested I've got one of these:

02:00.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
	Subsystem: Belkin F5D7010 Wireless G Notebook Network Card
	Flags: bus master, slow devsel, latency 64, IRQ 16
	Memory at 54000000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [40] Power Management version 2

Regards,

--
Andy Price

