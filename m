Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59711 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab2DSEW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 00:22:29 -0400
Received: by lahc1 with SMTP id c1so6406201lah.26
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 21:22:26 -0700 (PDT)
Message-ID: <1334809343.4965.40.camel@cumari> (sfid-20120419_062233_315076_0BF08016)
Subject: Re: wl12xx: fix DMA-API-related warnings
From: Luciano Coelho <coelho@ti.com>
To: Mircea Gherzan <mgherzan@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 19 Apr 2012 07:22:23 +0300
In-Reply-To: <4F8F476B.3040800@gmail.com>
References: <20120416104858.GA24159@elgon.mountain>
	 <4F8F476B.3040800@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mircea,

On Thu, 2012-04-19 at 00:59 +0200, Mircea Gherzan wrote: 
> Hi Luciano,
> 
> Am 16.04.2012 12:48, schrieb Dan Carpenter:
> > Hello Mircea Gherzan,
> > 
> > The patch 690142e98826: "wl12xx: fix DMA-API-related warnings" from
> > Mar 17, 2012, leads to the following Smatch warning:
> > drivers/net/wireless/ti/wlcore/cmd.c:126 wl1271_cmd_wait_for_event_or_timeout()
> > 	 error: no modifiers for allocation.
> 
> How would you prefer my fix for this issue: as a new version of the
> original patch or as a separate new patch?

I have already applied and pushed your patch, so send a separate new
patch on top of it, please.

Actually, Dan already sent one fix, but it only fixes one place, I think
we need to fix a couple more places too:

http://www.spinics.net/lists/linux-wireless/msg88626.html

-- 
Cheers,
Luca.

