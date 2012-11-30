Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54778 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030416Ab2K3N3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 08:29:34 -0500
Message-ID: <50B8B4AB.4060102@hauke-m.de> (sfid-20121130_142938_873018_C1897A7A)
Date: Fri, 30 Nov 2012 14:29:15 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: john@phrozen.org, ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org, m@bues.ch
Subject: Re: [PATCH v3 0/8] bcma/ssb/BCM47XX: add GPIO driver to ssb/bcma
References: <1353453874-523-1-git-send-email-hauke@hauke-m.de> <CACna6rzGE=CaD_9yAaTDkR6CuUy1HqRq1-v+fAd-Zg-uMmH2bQ@mail.gmail.com>
In-Reply-To: <CACna6rzGE=CaD_9yAaTDkR6CuUy1HqRq1-v+fAd-Zg-uMmH2bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2012 02:11 PM, Rafał Miłecki wrote:
> 2012/11/21 Hauke Mehrtens <hauke@hauke-m.de>:
>> This is a complete rewrote of the original patch "MIPS: BCM47xx: use
>> gpiolib"
>> Instead of providing the GPIO driver in the arch code it is now moved
>> into ssb and bcma and could also be used by other systems. The GPIO
>> functions in drivers/ssb/embedded.c are still used by arch/mips/bcm47xx
>> /wgt634u.c, but I am planing to write some code for baord detection and
>> a driver for LED and the buttons, after that wgt634u.c could be removed.
>>
>> This is based on mips/master tree.
> 
> Is this patches supposed to appear in
> http://git.kernel.org/?p=linux/kernel/git/ralf/linux.git;a=summary
> ? Just so I can know where to look for it.
> 
Hi Rafał,

It is in a mips tree at [0] and it is also in linux-next.

Hauke

[0]: http://git.linux-mips.org/?p=ralf/upstream-sfr.git;a=summary

