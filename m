Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40591 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab1GETHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 15:07:07 -0400
Received: by mail-bw0-f51.google.com with SMTP id 18so7305466bwa.24
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 12:06:33 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: one SDIO initialization is enough
From: Luciano Coelho <coelho@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1309100411-15353-1-git-send-email-ohad@wizery.com>
References: <1309100411-15353-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 22:06:30 +0300
Message-ID: <1309892790.1514.506.camel@cumari> (sfid-20110705_210710_596399_C0712F6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-06-26 at 18:00 +0300, Ohad Ben-Cohen wrote: 
> Skip manual device power on in case runtime PM is enabled for
> our device.
> 
> This eliminates a secondary & redundant SDIO init sequence.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
> This patch depends on "wl12xx: don't bail if mmc isn't MMC_CAP_POWER_OFF_CARD"
> 
> https://patchwork.kernel.org/patch/827772/

Thanks, Ohad, applied!

-- 
Cheers,
Luca.

