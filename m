Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34553 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757982Ab2BOKQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:16:04 -0500
Received: by lagp5 with SMTP id p5so1015723lag.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:16:01 -0800 (PST)
Message-ID: <1329300958.19569.40.camel@cumari> (sfid-20120215_111609_677368_473BCCE5)
Subject: Re: [PATCH v2 00/10] wl12xx: update fw api
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:15:58 +0200
In-Reply-To: <1328003845-3926-1-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 11:57 +0200, Eliad Peller wrote: 
> The fw api was changed in the latest FWs (6.3.5.0.95 for wl127x
> and 7.3.5.0.95 for wl128x).
> 
> Along with some small adjustments, the main changes
> inroduced by this patheset are configuring the
> templates per-role, and moving to IEEE80211_HW_SUPPORTS_DYNAMIC_PS
> mode.
> 
> v2:
> 	- prevent the driver from working in the transitional
> 	  commits (thanks Kalle & Luca)
> 	- squash some patches (thanks Luca)
> 
> Eliad Peller (4):
>   wl12xx: fw api change - add role_id to set_template
>   wl12xx: use dev_role_id for scans
>   wl12xx: fw api change - add role_id to tsf_info
>   wl12xx: fw api change - update cmd/acx/event enums
> 
> Eyal Shapira (6):
>   wl12xx: remove PS management code
>   wl12xx: add support for HW dynamic PS
>   wl12xx: add dynamic_ps_timeout debugfs file
>   wl12xx: remove 2 unused parameters in wl1271_ps_set_mode()
>   wl12xx: enable/disable BET with AUTO_PS/ACTIVE
>   wl12xx: change WLVIF_FLAG_PSM name and remove
>     WLVIF_FLAG_PSM_REQUESTED

Applied this series, thanks guys!

-- 
Cheers,
Luca.

