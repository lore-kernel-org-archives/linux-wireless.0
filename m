Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:42288 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751509Ab1KHMsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 07:48:04 -0500
Received: by mail-bw0-f49.google.com with SMTP id t2so603002bka.22
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 04:48:02 -0800 (PST)
Subject: Re: [PATCH] wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check
 that all given ssids are in filters
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320756132-14625-1-git-send-email-eyal@wizery.com>
References: <1320756132-14625-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 14:47:59 +0200
Message-ID: <1320756479.19479.6.camel@cumari> (sfid-20111108_134809_337410_EE47F3AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 14:42 +0200, Eyal Shapira wrote: 
> A minor fix for the check that verifies that all given SSIDs (in req) exist
> in the filters (the match sets)
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

Acked-by: Luciano Coelho <coelho@ti.com>

John, can you apply this to 3.2, please?

-- 
Cheers,
Luca.

