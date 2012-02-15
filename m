Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:44374 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759011Ab2BOKTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:19:31 -0500
Received: by mail-lpp01m010-f53.google.com with SMTP id d3so863129lah.12
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:19:30 -0800 (PST)
Message-ID: <1329301167.19569.44.camel@cumari> (sfid-20120215_111940_563548_D4872E57)
Subject: Re: [PATCH] wl12xx: declare support for hw scan while idle
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:19:27 +0200
In-Reply-To: <1328181335-8155-1-git-send-email-eliad@wizery.com>
References: <1328181335-8155-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 13:15 +0200, Eliad Peller wrote: 
> By allowing hw scan while idle, we no longer
> need the redundant ROC/CROC that are done
> on idle off/on, which helps simplifying the
> state machine of the driver.
> 
> This way, we can also allow scanning while
> there is an ongoing sched scan (otherwise,
> we won't be able to ROC on idle-off)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> depends on "mac80211: support hw scan while idle"
> 
>  drivers/net/wireless/wl12xx/main.c |    7 ++-----
>  drivers/net/wireless/wl12xx/scan.c |   13 -------------
>  2 files changed, 2 insertions(+), 18 deletions(-)

Applied, thanks!


-- 
Cheers,
Luca.

