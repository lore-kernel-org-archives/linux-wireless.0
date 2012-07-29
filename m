Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37638 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2G2PZf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 11:25:35 -0400
Message-ID: <501555E3.8080304@hauke-m.de> (sfid-20120729_172540_346281_4CBF7F0B)
Date: Sun, 29 Jul 2012 17:25:23 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac and BCM47186 (BCM5357) + brcmfmac and BCM43236 V2
References: <4FB57C61.3090302@hauke-m.de> <CACna6rzO2579YdN_GdmP+=-+L308KjKhKsejevAzJ19dp6LxVg@mail.gmail.com>
In-Reply-To: <CACna6rzO2579YdN_GdmP+=-+L308KjKhKsejevAzJ19dp6LxVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2012 01:34 PM, Rafał Miłecki wrote:
> 2012/5/18 Hauke Mehrtens <hauke@hauke-m.de>:
>> I got a new device, a Linksys E3200 with a BCM47186 (id: 0x5357) and a
>> BCM43236 v2 for 5GHz wifi.
>>
>> The BCM47186 has a wifi core rev 28, a N-PHY rev 9 and a 2057 radio rev
>> 5 and it does not work with brcmsmac or b43. :-(
>>
>> Are there plans to add support for such new N-PHY revs to brcmsmac and
>> the firmware?
>>
>> Here are some parts of my log with brcmsamc with firmware from
>> linux-firmware.
>>
>> bcma: Found chip with id 0x5357, rev 0x02 and package 0x0A
>> ....
>> bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x1C, class 0x0)
>> ....
>> [   14.776000] b43-phy0: Broadcom 5357 WLAN found (core revision 28)
>> [   14.780000] b43-phy0 debug: Found PHY: Analog 9, Type 4, Revision 9
> 
> Hauke, is this 0x5357 a SoC bcma, or additional bcma connected via
> PCIE to the main one? If it's the second case, could you provide pci
> id, please?
> 
Hi Rafał,

0x5357 is a SoC with a ieee80211 core, but no PCIe core, just USB 2.0.
Should I add all the SoC chips I know of to the b43 device list?

Hauke
