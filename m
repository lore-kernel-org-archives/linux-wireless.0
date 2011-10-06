Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:44158 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758250Ab1JFNQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 09:16:48 -0400
Received: by bkbzu17 with SMTP id zu17so3095251bkb.10
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 06:16:45 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: set max_sched_scan_ie_len correctly
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1317129755-14825-1-git-send-email-coelho@ti.com>
References: <1317129755-14825-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 16:16:37 +0300
Message-ID: <1317906997.3549.6.camel@cumari> (sfid-20111006_151651_693725_21083810)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 16:22 +0300, Luciano Coelho wrote: 
> The wiphy max_sched_scan_ie_len attribute was not set correctly and
> remained as 0, so when IEs were being passed in a scheduled scan, we
> were returning -EINVAL.
> 
> Fix this by setting the attribute properly.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

