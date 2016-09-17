Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42569 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752389AbcIQPhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 11:37:39 -0400
Date: Sat, 17 Sep 2016 08:37:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix wlcore config firwmare annoyances
Message-ID: <20160917153735.lokxw5kdgtmvtmge@atomide.com> (sfid-20160917_173743_515306_C9EB292E)
References: <20160913215043.29454-1-tony@atomide.com>
 <87k2ea7dmm.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k2ea7dmm.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Kalle Valo <kvalo@codeaurora.org> [160917 08:25]:
> Tony Lindgren <tony@atomide.com> writes:
> 
> > Hi all,
> >
> > Here are some patches to fix the firmware loading for wl12xx/wl18xx
> > when the same rootfs is used on multiple WLAN chip variants.
> >
> > Regards,
> >
> > Tony
> >
> > Tony Lindgren (5):
> >   wlcore: Prepare family to fix nvs file handling
> >   wlcore: sdio: Populate config firmware data
> >   wlcore: sdio: Populate config firmware data
> >   wlcore: Fix config firmware loading issues
> >   wlcore: wl18xx: Use chip specific configuration firmware
> 
> I saw a new warning which I think is a valid one:
> 
> drivers/net/wireless/ti/wlcore/main.c: In function 'wlcore_probe':
> drivers/net/wireless/ti/wlcore/main.c:6518:6: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]

Oops sorry about that, will check and repost.

Regards,

Tony
