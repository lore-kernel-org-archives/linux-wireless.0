Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39105 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab2LKMP0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 07:15:26 -0500
Message-ID: <1355228082.3738.135.camel@cumari.coelho.fi> (sfid-20121211_131530_149614_A91F4526)
Subject: Re: [PATCH 00/20] wlcore fixes for 3.8 (part3)
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 11 Dec 2012 14:14:42 +0200
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> This series applies on top of part 2 sent a couple days ago.
> 
> The main addition is support for mac80211 HW queues and further
> optimizations for Tx in the multi-channel case.
> 
> Arik Nemtsov (11):
>   wlcore: remove support for injected Tx
>   wlcore: improve handling for Rx errors
>   wlcore: set 5Ghz probe-req template for DFS channels
>   wlcore/wl18xx: change priority calculations for links
>   wl18xx: limit Tx for the AP single-STA-in-PSM case
>   wlcore: use link count for single-STA-PSM optimization
>   wlcore: use separate HW queue for each AC in each vif
>   wlcore: don't take mutex before stopping queues
>   wlcore: consolidate Rx BA bitmap management to links struct
>   wl18xx: support MIMO only if HT mode is not forced to SISO
>   wl18xx: count HW block spare based correctly on keys
> 
> Eliad Peller (1):
>   wlcore: add ACX_PEER_CAP command
> 
> Eyal Shapira (2):
>   wlcore: increase scan dwell times if no activity
>   wlcore: support scan reports during periodic scan
> 
> Ido Reis (1):
>   wl12xx/wl18xx: update default fw logger's settings
> 
> Ido Yariv (1):
>   wlcore: Always pass DMA-able buffers to mmc functions
> 
> Igal Chernobelsky (1):
>   wlcore/wl18xx/wl12xx: FW log params per chip arch
> 
> Yair Shapira (3):
>   wlcore: add new plt power-mode: CHIP_AWAKE
>   wlcore: disable elp sleep while in plt mode
>   wl18xx: fix a bug in wl->num_rx_desc initialization

Applied the whole series, except 03/20, 08/20 and 09/20, for which I'm
waiting more information or rework, and 01/20, which I dropped entirely.

Some changes were made to some of the patches according to the
discussions on the respective threads.  In all cases, I used the latest
version sent, when rework was needed.

Thanks!

--
Luca.

