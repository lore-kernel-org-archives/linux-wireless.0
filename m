Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:42373 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935666Ab1ETMJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:09:30 -0400
Received: by ewy24 with SMTP id 24so1403360ewy.4
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:09:27 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: change TX BA window size to 8
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1305879925-10322-1-git-send-email-coelho@ti.com>
References: <1305879925-10322-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:09:24 +0300
Message-ID: <1305893364.12586.1674.camel@cumari> (sfid-20110520_140933_213475_C165E30E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-20 at 11:25 +0300, Luciano Coelho wrote:
> The wl12xx firmware only supports window size of 8 frames in TX BA
> sessions.  Currently we are configuring it to 64, which is not
> supported and causes problems (ie. firmware crashes).
> 
> Fix this by changing the tx_ba_win_size configuration to 8.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

I'm holding this one back for a while.  It seems that using 8 for the
win_size is more robust, but we're still discussing with firmware people
what the actual cause of the firmware crash is, since, in theory, a
window size of 64 should be fine.

-- 
Cheers,
Luca.

