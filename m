Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:53678 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055Ab1CCPnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:43:55 -0500
Received: by mail-ew0-f42.google.com with SMTP id 1so615186ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 07:43:54 -0800 (PST)
Subject: Re: [PATCH v2 0/7] wl12xx: Optimizing throughput and CPU usage
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298985284-6048-1-git-send-email-ido@wizery.com>
References: <1298985284-6048-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 17:43:57 +0200
Message-ID: <1299167037.7039.7.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 15:14 +0200, Ido Yariv wrote:
> The following patches tweak the driver in multiple places to achieve maximal
> throughput and minimal CPU usage.
> 
> Throughput improved significantly with these patches, up to 50% increase in
> some cases.
> 

[...]

> Ido Yariv (7):
>   wl12xx: Reorder data handling in irq_work
>   wl12xx: Do end-of-transactions transfers only if needed
>   wl12xx: Change claiming of the SDIO bus
>   wl12xx: Switch to a threaded interrupt handler
>   wl12xx: Switch to level trigger interrupts
>   wl12xx: Avoid redundant TX work
>   wl12xx: Modify requested number of memory blocks

Applied the entire series with one small modification:

s/BIT(1)/BIT(0)/ in the second patch.

This is great work, thanks a lot, Ido!

-- 
Cheers,
Luca.

