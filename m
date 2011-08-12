Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42915 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1HLPOr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 11:14:47 -0400
Message-ID: <4E45435E.9020900@hauke-m.de> (sfid-20110812_171450_631489_CBD9027D)
Date: Fri, 12 Aug 2011 17:14:38 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
References: <1313156101-16817-1-git-send-email-arend@broadcom.com> <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com>
In-Reply-To: <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 04:02 PM, Rafał Miłecki wrote:
> 2011/8/12 Arend van Spriel <arend@broadcom.com>:
>> Several cleanup patches to reduce code for the brcmfmac driver and
>> get rid of a remaining checkpatch warning. The driver sources should
>> be clear from checkpatch issue now.
>>
>> This series applies to staging-next and depends on the following patch set:
> 
> Are you testing patches on some hardware? Or just compile-testing?
> 
> I believe this driver is meant to support BCM4329, which is not PCI(e)
> board. What adapter do you use?
> 
> I've heard about Arasan adapter. Have you tried it? Is that something
> reachable from arasan.com?
> 

Is there also a softmac version of the BCM4329 available? The wl driver
shipped with the vendor firmware of my BCM4716 device detects one of the
wifi chips as BCM4329. I think it is the one in the BCM4716 and that is
already supported by b43. Or is this a wrong information?

Here is the output of the kernel log:
eth0: Broadcom BCM47XX 10/100/1000 Mbps Ethernet Controller 5.10.144.3
eth1: Broadcom BCM4329 802.11 Wireless Controller 5.10.144.5
PCI: Enabling device 01:01.0 (0000 -> 0002)
eth2: Broadcom BCMa8d8 802.11 Wireless Controller 5.10.144.5

Hauke
