Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:47021 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755161Ab1EKQG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:06:27 -0400
Received: by mail-ey0-f172.google.com with SMTP id 13so298804eye.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:06:26 -0700 (PDT)
Subject: Re: [PATCH 0/7] wl12xx: add initial wowlan support
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305104068-32240-1-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 11:57:48 +0300
Message-ID: <1305104269.12586.746.camel@cumari> (sfid-20110511_180659_408038_F4AD9DF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
> Note that this patchset needs some additional omap/mmc patches in 
> order to support the MMC_PM_KEEP_POWER flag and wake-irq correctly
> (however, if the MMC_PM_KEEP_POWER flag is not being supported we 
> don't advertise support for wowlan triggers, so this patchset alone
> shouldn't harm). 

Do you know if these patches are queued in linux-omap for 2.6.40?

-- 
Cheers,
Luca.

