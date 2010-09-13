Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from compulab.co.il ([67.18.134.219]:54221 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0IMIBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 04:01:10 -0400
Message-ID: <4C8DD9F4.5090305@compulab.co.il>
Date: Mon, 13 Sep 2010 09:59:48 +0200
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
References: <20100908150322.17dac9c3@nehalam> <20100908225132.GA12490@kroah.com> <4C88F8CE.5090708@broadcom.com>
In-Reply-To: <4C88F8CE.5090708@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henry,

Henry Ptasinski wrote:
> Broadcom would like to announce the initial release of a fully-open
> Linux driver for it's latest generation of 11n chipsets.  The driver,
> while still a work in progress, is released as full source and uses the
> native mac80211 stack.   It supports multiple current chips (BCM4313,
> BCM43224, BCM43225) as well as providing a framework for supporting
> additional chips in the future, including mac80211-aware embedded chips.
>   The README and TODO files included with the sources provide more
> details about the current feature set, known issues, and plans for
> improving the driver.
> 
> The driver is currently available in staging-next git tree, available at:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git 
> 
> 
> in the drivers/staging/brcm80211 directory.

Are there any plans to support BCM4319 and BCM4329 SDIO chipsets?

> ---
> Henry Ptasinski
> henryp@broadcom.com
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Sincerely yours,
Mike.
