Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45847
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbYKZAOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 19:14:52 -0500
Date: Tue, 25 Nov 2008 16:14:51 -0800 (PST)
Message-Id: <20081125.161451.142025705.davem@davemloft.net> (sfid-20081126_011459_790377_949533E4)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-11-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081125221753.GC25962@tuxdriver.com>
References: <20081125221753.GC25962@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 25 Nov 2008 17:17:53 -0500

>  arch/arm/configs/eseries_pxa_defconfig         |    7 +-
>  arch/arm/configs/ezx_defconfig                 |   16 +-
>  arch/arm/configs/overo_defconfig               |    7 +-
>  arch/arm/configs/s3c2410_defconfig             |   15 +-
>  arch/mips/configs/bcm47xx_defconfig            |   18 +-
>  arch/mips/configs/sb1250-swarm_defconfig       |    6 +-
>  arch/powerpc/configs/pmac32_defconfig          |   10 +-
>  arch/powerpc/configs/ppc6xx_defconfig          |   10 +-
>  arch/powerpc/configs/ps3_defconfig             |    7 +-
>  arch/sh/configs/ul2_defconfig                  |    9 +-
>  arch/x86/configs/i386_defconfig                |    7 +-
>  arch/x86/configs/x86_64_defconfig              |    7 +-

Hey John.  We don't muck with arch defconfig files like
this, even when making Kconfig changes.

This makes life difficult for arch maintainers.

Could you please toss out these parts and send me another
pull request?

Thanks.
