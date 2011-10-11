Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:59419 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010Ab1JKSCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 14:02:46 -0400
Received: by mail-bw0-f47.google.com with SMTP id 11so10234663bke.6
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 11:02:44 -0700 (PDT)
Subject: Re: [RFC] wl12xx: use the same plat dev name for both SPI and SDIO
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: balbi@ti.com
In-Reply-To: <1317992414-30197-1-git-send-email-coelho@ti.com>
References: <1317992414-30197-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 21:02:37 +0300
Message-ID: <1318356157.9690.533.camel@cumari> (sfid-20111011_200248_810677_4B9B8511)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 16:00 +0300, Luciano Coelho wrote: 
> There's no need to have the bus name included in the platform device
> name that we create.  The core driver doesn't need to know about the
> type of bus it uses.  Any differences between the buses that need to
> be handled differently in the core, can be passed in the platform data
> (as the pwr_in_suspend boolean does).
> 
> Use "wl12xx" for the device name in both bus drivers.  Rename the
> platform driver name to "wl12xx_driver", just to differentiate from
> the platform device names.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Nobody complained about this (except Arik, but I answered his question),
so I decided to apply this.  I won't re-send it as PATCH, because that
would be useless. ;)

-- 
Cheers,
Luca.

