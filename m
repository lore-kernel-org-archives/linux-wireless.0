Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52204 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2K3NSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 08:18:52 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so7105091wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2012 05:18:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353453874-523-1-git-send-email-hauke@hauke-m.de>
References: <1353453874-523-1-git-send-email-hauke@hauke-m.de>
Date: Fri, 30 Nov 2012 14:11:35 +0100
Message-ID: <CACna6rzGE=CaD_9yAaTDkR6CuUy1HqRq1-v+fAd-Zg-uMmH2bQ@mail.gmail.com> (sfid-20121130_141858_811619_52174EE4)
Subject: Re: [PATCH v3 0/8] bcma/ssb/BCM47XX: add GPIO driver to ssb/bcma
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: john@phrozen.org, ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org, m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/21 Hauke Mehrtens <hauke@hauke-m.de>:
> This is a complete rewrote of the original patch "MIPS: BCM47xx: use
> gpiolib"
> Instead of providing the GPIO driver in the arch code it is now moved
> into ssb and bcma and could also be used by other systems. The GPIO
> functions in drivers/ssb/embedded.c are still used by arch/mips/bcm47xx
> /wgt634u.c, but I am planing to write some code for baord detection and
> a driver for LED and the buttons, after that wgt634u.c could be removed.
>
> This is based on mips/master tree.

Is this patches supposed to appear in
http://git.kernel.org/?p=linux/kernel/git/ralf/linux.git;a=summary
? Just so I can know where to look for it.

-- 
Rafał
