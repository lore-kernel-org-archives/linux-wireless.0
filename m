Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59988 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab2K1JM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:12:57 -0500
Message-ID: <1354093937.25524.14.camel@cumari.coelho.fi> (sfid-20121128_101300_576099_A745F0B3)
Subject: Re: [PATCH v2 00/14] update 18xx api
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 28 Nov 2012 11:12:17 +0200
In-Reply-To: <1353600384-32462-1-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-22 at 18:06 +0200, Eliad Peller wrote:
> This patchset updates wl18xx to use the latest
> 18xx fw api.
> 
> Most of the commands are backward compatible with
> the 12xx fw (e.g. new fields were added at the
> end of the existing structs).
> 
> However, the scan and event mailbox apis were
> completely changed, so we had to split the
> existing code (while trying to reuse as much
> code as possible).
> 
> After this patchset, the driver can work with
> latest versions of both 12xx and 18xx FWs.
> 
> v2: handle Luca's comments
> 
> Eliad Peller (13):
>   wlcore: don't call ieee80211_sched_scan_stopped directly
>   wlcore: make scan scan configuration functions more generic
>   wl18xx: change fw name and temporarily fail loading
>   wlcore: update commands enum to new fw api
>   wlcore: split 18xx and 12xx scan mechanism
>   wl18xx: increase MAX_CHANNELS_5GHZ
>   wlcore: update acx enum
>   wlcore: update channel_switch/stop_channel_switch commands
>   wlcore: update events enum/struct to new fw api
>   wlcore: pass wmm configuration to the fw
>   wlcore: save session_id per-link
>   wlcore: call ieee80211_sched_scan_stopped on interface removal
>   wl18xx: make driver operational again
> 
> Victor Goldenshtein (1):
>   wlcore: add new reg-domain configuration command

Applied, thank you!

--
Luca.

