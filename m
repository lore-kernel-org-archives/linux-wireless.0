Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32856 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab1FCNnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 09:43:22 -0400
Received: by wya21 with SMTP id 21so1399464wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 06:43:21 -0700 (PDT)
Message-ID: <4DE8E4F5.7010009@arif-ali.co.uk> (sfid-20110603_154332_637851_4F6D6A35)
Date: Fri, 03 Jun 2011 14:43:17 +0100
From: Arif Ali <mail@arif-ali.co.uk>
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: linux-wireless@vger.kernel.org, larry.finger@lwfinger.net
Subject: Re: r8192se_pci or rtlwifi/rtl8192ce
References: <4DE7D5FD.2050707@arif-ali.co.uk> <20110603130308.GB2379@nautilus.holoscopio.com>
In-Reply-To: <20110603130308.GB2379@nautilus.holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/11 14:03, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Jun 02, 2011 at 07:27:09PM +0100, Arif Ali wrote:
>> Hi,
>>
>> I was asked to post to this list wrt the problem I have with the wireless on
>> my new laptop
>>
>> I have just bought a Thinkpad Edge 15, which has the following card
>>
>>   *-network
>>        description: Wireless interface
>>        product: RTL8191SEvB Wireless LAN Controller
>>        vendor: Realtek Semiconductor Co., Ltd.
>>        physical id: 0
>>        bus info: pci@0000:09:00.0
>>        logical name: wlan0
>>        version: 10
>>        serial: 5c:ac:4c:bc:27:1e
>>        width: 32 bits
>>        clock: 33MHz
>>        capabilities: bus_master cap_list ethernet physical wireless
>>        configuration: broadcast=yes driver=rtl819xSE
>> driverversion=0019.1207.2010 firmware=63 ip=192.168.10.51 latency=0
>> multicast=yes wireless=802.11bg
>>        resources: irq:18 ioport:d000(size=256) memory:d0500000-d0503fff
>>
>> I have then tried to re-compile the drivers from realtek, with no avail,
>> having similar problems
>>
>> At the moment in Ubuntu 11.04, I am using r8192se_pci, which seems to be
>> very flakey to say the least, where my connections from remote servers
>> disconnect within 5 minutes. It was suggested to me that I use the
>> compat-wireless drivers, of which I did
>>
>> I tried loading the rtlwifi with rtl8192ce, but that didn't work and didn't
>> see my card, but then I guess that would be expected as the aliases were not
>> there for my card. although the DID is mentioned in the pci.h, so I was
>> wondering would this driver work with my card, or should I be looking
>> elsewhere?
>>
>> Any input on advice on this card would be appreciated
>> thanks
>>
>> Arif Ali
>>
>> --
>> Arif Ali
>>
>
> Hello, Arif.
>
> I have a RTL8191SEvA card, not a vB. But I guess that should work. The
> vendor and product ID are 0x10ec (Realtek) and 0x8171. It's working very
> nicely with rtl8192se driver from rtlwifi from 3.0-rc1. That support
> does not exist for 2.6.39 or previous versions of Linux.
>
> Regards,
> Cascardo.

OK, will try the 3.0-rc1 kernel from ubuntu, see if it will work, thanks 
for your reply

-- 
Arif Ali
