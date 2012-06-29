Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51679 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2F2Qk6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 12:40:58 -0400
Message-ID: <4FEDDA91.2050805@hauke-m.de> (sfid-20120629_184101_759762_275D5CD1)
Date: Fri, 29 Jun 2012 18:40:49 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, b43-dev@lists.infradead.org,
	arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] bcma misc updates
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de> <CACna6rxL8xya8eOfBUvT43y0ZhHWKJyEef1G2pe5THi4DfOmkQ@mail.gmail.com>
In-Reply-To: <CACna6rxL8xya8eOfBUvT43y0ZhHWKJyEef1G2pe5THi4DfOmkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2012 09:44 AM, Rafał Miłecki wrote:
> 2012/6/5 Hauke Mehrtens <hauke@hauke-m.de>:
>> These are some updates for bcma. Some are extending or completing some
>> workarounds for PCIe based wireless cards. A patch adds
>> bcma_pmu_spuravoid_pllupdate, used by brcmsmac and an other patch adds
>> constants for the chip ids. This code is mostly based on code from
>> brcmsmac and the Broadcom SDK for BCM47XX SoCs.
>>
>> This was tested on a BCM4718 SoC with a BCM43224 PCIe and a BCM5357.
>> The Wifi part of the BCM4718 and BCM43224 is more or less working with
>> brcmsmac, which need some more patches for that, but it has low speed
>> and some times or with some access points I still get errors. The wifi
>> of the BCM5357 does not work.
>>
>> Hauke Mehrtens (8):
>>  bcma: extend workaround for bcm4331
>>  bcma: add constants for chip ids
>>  bcma: Fix for 4329b0 bad LPOM is detection
>>  bcma: add PCI ID for BCM43224
>>  bcma: complete workaround for BCMA43224 and BCM4313
>>  bcma: handle SoCs in pmu initialization
>>  bcma: add bcma_pmu_spuravoid_pllupdate()
>>  bcma: add mdelay bcma_pmu_resources_init()
> 
> John: can you take the following patches from this patchset?
> 1/8
> 2/8
> 4/8
> 5/8
> 7/8
> 
> Following patches should be dropped:
> 3/8 - BCM4329 fix should be dropped, not improved
> 6/8 - functions touched by patch should be dropper, not improved
> 8/8 - patch is fine, but doesn't apply cleanly
> 
I am ok with that, but I am also planing to send a v2 of these patch
series and the one for brcmsmac today.

Hauke

