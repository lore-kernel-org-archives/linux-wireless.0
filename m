Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:40145 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab1LHWIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 17:08:36 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id p5so1278438lag.33
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 14:08:34 -0800 (PST)
Subject: Re: [PATCH] wl12xx: silence tx_attr uninitialized warning in
 wl1271_tx_fill_hdr
From: Luciano Coelho <coelho@ti.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
In-Reply-To: <1323378958-13748-1-git-send-email-linville@tuxdriver.com>
References: <1323378958-13748-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 00:08:31 +0200
Message-ID: <1323382111.8996.275.camel@cumari> (sfid-20111208_230839_448751_BA1CBC82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 16:15 -0500, John W. Linville wrote: 
> CC [M]  drivers/net/wireless/wl12xx/tx.o
> drivers/net/wireless/wl12xx/tx.c: In function ‘wl1271_tx_fill_hdr’:
> drivers/net/wireless/wl12xx/tx.c:288:6: warning: ‘tx_attr’ may be used uninitialized in this function
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---

Ooops! Sorry, John, and thanks for fixing it.  My compiler (gcc for arm)
doesn't seem to report it.

We had already seen this and it had been fix in our internal tree.
Unfortunately we forgot to include this when sending upstream.

-- 
Cheers,
Luca.

