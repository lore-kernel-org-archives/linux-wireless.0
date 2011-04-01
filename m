Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:39668 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab1DALaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:30:12 -0400
Received: by ewy1 with SMTP id 1so1378127ewy.41
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 04:30:10 -0700 (PDT)
Subject: Re: [PATCH 0/5] wl12xx: Cleanups & fixes
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301558821-17787-1-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 14:30:48 +0300
Message-ID: <1301657448.1988.483.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-31 at 10:06 +0200, Ido Yariv wrote:
> The following patches mostly clean up code, but also fix a few minor bugs.
> 
> The first four patches fix a few issues in the recently added 128x support.
> The last patch fixes a regression in the driver, preventing it from working
> properly on platforms which do not support level triggered interrupts.
> 
> Ido Yariv (5):
>   wl12xx: Clean up and fix the 128x boot sequence
>   wl12xx: Clean up the block size alignment code
>   wl12xx: Clean up the dummy packet mechanism
>   wl12xx: Simplify TX blocks accounting
>   wl12xx: Handle platforms without level trigger interrupts
> 
>  drivers/net/wireless/wl12xx/acx.c    |    2 -
>  drivers/net/wireless/wl12xx/boot.c   |  235 +++++++++++++++++-----------------
>  drivers/net/wireless/wl12xx/boot.h   |    1 +
>  drivers/net/wireless/wl12xx/init.c   |    2 +-
>  drivers/net/wireless/wl12xx/io.c     |    3 +-
>  drivers/net/wireless/wl12xx/main.c   |  140 +++++++++++++--------
>  drivers/net/wireless/wl12xx/sdio.c   |   21 ++--
>  drivers/net/wireless/wl12xx/spi.c    |    9 +-
>  drivers/net/wireless/wl12xx/tx.c     |   70 +++++++----
>  drivers/net/wireless/wl12xx/tx.h     |   11 ++-
>  drivers/net/wireless/wl12xx/wl12xx.h |   23 ++-
>  include/linux/wl12xx.h               |   14 ++-
>  12 files changed, 305 insertions(+), 226 deletions(-)

Applied the 3 remaining patches of the series too, so all this patchset
has been applied.  Thanks!

-- 
Cheers,
Luca.

