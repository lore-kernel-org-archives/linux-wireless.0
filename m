Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62935 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992844Ab2K3T1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 14:27:24 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so256017wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2012 11:27:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B8B4AB.4060102@hauke-m.de>
References: <1353453874-523-1-git-send-email-hauke@hauke-m.de>
	<CACna6rzGE=CaD_9yAaTDkR6CuUy1HqRq1-v+fAd-Zg-uMmH2bQ@mail.gmail.com>
	<50B8B4AB.4060102@hauke-m.de>
Date: Fri, 30 Nov 2012 20:27:22 +0100
Message-ID: <CACna6ryzM-32BmF0BipEg+q8hr9kAjPP=_vzCvgssgnVe_muHw@mail.gmail.com> (sfid-20121130_202733_709609_C331D36B)
Subject: Re: [PATCH v3 0/8] bcma/ssb/BCM47XX: add GPIO driver to ssb/bcma
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: john@phrozen.org, ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org, m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/30 Hauke Mehrtens <hauke@hauke-m.de>:
> On 11/30/2012 02:11 PM, Rafał Miłecki wrote:
>> 2012/11/21 Hauke Mehrtens <hauke@hauke-m.de>:
>>> This is a complete rewrote of the original patch "MIPS: BCM47xx: use
>>> gpiolib"
>>> Instead of providing the GPIO driver in the arch code it is now moved
>>> into ssb and bcma and could also be used by other systems. The GPIO
>>> functions in drivers/ssb/embedded.c are still used by arch/mips/bcm47xx
>>> /wgt634u.c, but I am planing to write some code for baord detection and
>>> a driver for LED and the buttons, after that wgt634u.c could be removed.
>>>
>>> This is based on mips/master tree.
>>
>> Is this patches supposed to appear in
>> http://git.kernel.org/?p=linux/kernel/git/ralf/linux.git;a=summary
>> ? Just so I can know where to look for it.
>>
> Hi Rafał,
>
> It is in a mips tree at [0] and it is also in linux-next.
>
> Hauke
>
> [0]: http://git.linux-mips.org/?p=ralf/upstream-sfr.git;a=summary

Thanks for pointing as well as for your work!

-- 
Rafał
