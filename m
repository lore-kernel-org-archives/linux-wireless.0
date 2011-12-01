Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39028 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665Ab1LAOiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:38:23 -0500
Received: by laah2 with SMTP id h2so1272630laa.39
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:38:20 -0800 (PST)
Subject: Re: [PATCH] wl12xx: don't explicitly check for unjoined ibss
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320761272-20915-1-git-send-email-eliad@wizery.com>
References: <1320761272-20915-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:38:17 +0200
Message-ID: <1322750297.8996.37.camel@cumari> (sfid-20111201_153830_578693_B0848F3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 16:07 +0200, Eliad Peller wrote: 
> After the ibss carrier issue was fixed, we can revert
> the following patch:
> 
> commit 48309fd477ef867babb6819f67fe082c133a5fa9
> Author: Shahar Lev <shahar@wizery.com>
> Date:   Fri Oct 7 18:17:25 2011 +0200
> 
>     wl12xx: remove warning message during IBSS Tx
> 
>     mac80211 sets the carrier on an IBSS interface even when no network is
>     joined. Ignore garbage frames transmitted on a disconnected IBSS
>     interface without printing warnings.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied!

-- 
Cheers,
Luca.

