Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:40658 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758884Ab1LOOXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 09:23:47 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id j5so2089847lag.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 06:23:46 -0800 (PST)
Subject: Re: [PATCH] wl12xx: alloc buffer in driver_state_read to prevent
 compilation warning
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1323953888-10988-1-git-send-email-coelho@ti.com>
References: <1323953888-10988-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 16:23:42 +0200
Message-ID: <1323959022.2800.186.camel@cumari> (sfid-20111215_152352_603274_9865D484)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-15 at 14:58 +0200, Luciano Coelho wrote: 
> When compiling wl12xx for x86, there was a warning complaining about
> the size of the buffer we were allocating in the stack:
> 
> drivers/net/wireless/wl12xx/debugfs.c: In function 'driver_state_read':
> drivers/net/wireless/wl12xx/debugfs.c:380:1: warning: the frame size of 1040 bytes is larger than 1024 bytes
> 
> To prevent this, allocate the buffer in the heap instead.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

