Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61078 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1FBS1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 14:27:13 -0400
Received: by wya21 with SMTP id 21so822303wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 11:27:11 -0700 (PDT)
Message-ID: <4DE7D5FD.2050707@arif-ali.co.uk> (sfid-20110602_202717_391379_86C20D3A)
Date: Thu, 02 Jun 2011 19:27:09 +0100
From: Arif Ali <mail@arif-ali.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: larry.finger@lwfinger.net
Subject: r8192se_pci or rtlwifi/rtl8192ce
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was asked to post to this list wrt the problem I have with the wireless on
my new laptop

I have just bought a Thinkpad Edge 15, which has the following card

  *-network
       description: Wireless interface
       product: RTL8191SEvB Wireless LAN Controller
       vendor: Realtek Semiconductor Co., Ltd.
       physical id: 0
       bus info: pci@0000:09:00.0
       logical name: wlan0
       version: 10
       serial: 5c:ac:4c:bc:27:1e
       width: 32 bits
       clock: 33MHz
       capabilities: bus_master cap_list ethernet physical wireless
       configuration: broadcast=yes driver=rtl819xSE
driverversion=0019.1207.2010 firmware=63 ip=192.168.10.51 latency=0
multicast=yes wireless=802.11bg
       resources: irq:18 ioport:d000(size=256) memory:d0500000-d0503fff

I have then tried to re-compile the drivers from realtek, with no avail,
having similar problems

At the moment in Ubuntu 11.04, I am using r8192se_pci, which seems to be
very flakey to say the least, where my connections from remote servers
disconnect within 5 minutes. It was suggested to me that I use the
compat-wireless drivers, of which I did

I tried loading the rtlwifi with rtl8192ce, but that didn't work and didn't
see my card, but then I guess that would be expected as the aliases were not
there for my card. although the DID is mentioned in the pci.h, so I was
wondering would this driver work with my card, or should I be looking
elsewhere?

Any input on advice on this card would be appreciated
thanks

Arif Ali

-- 
Arif Ali

