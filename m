Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:32866 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab2LKMKX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 07:10:23 -0500
Message-ID: <1355227779.3738.130.camel@cumari.coelho.fi> (sfid-20121211_131036_601123_E84254C3)
Subject: Re: [PATCH 00/20] wlcore fixes for 3.8 (part2)
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 11 Dec 2012 14:09:39 +0200
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> This series applies on top of part 1 sent yesterday.
> 
> The main addition is a new Tx scheduling algorithm for
> better multi-channel operation.
> 
> Arik Nemtsov (9):
>   wlcore: clear roc_vif on iface removal
>   wlcore: take the mutex before resetting Tx queues
>   wlcore: consolidate free_link and always call it
>   wlcore: initialize per-link FW freed blocks correctly
>   wlcore: track wlvif inside per-link structure
>   wlcore: count packets held per AC in each vif
>   wlcore: track FW-allocated packets per link
>   wlcore: improved Tx scheduling algorithm
>   wl18xx: set last Tx rate from FW status
> 
> Eliad Peller (4):
>   wlcore: allow fw commands to fail
>   wlcore: allow ACX_BA_SESSION_RX_SETUP to fail
>   wlcore: remove WLCORE_QUIRK_NO_ELP
>   wl18xx: declare support for greenfield ht_cap
> 
> Ido Reis (3):
>   wl18xx: update default mac/phy parameters
>   wlcore: fwlog dynamic mem_block control
>   wl18xx: FDSP Code RAM Corruption fix
> 
> Ido Yariv (1):
>   wlcore: Allow memory access when the FW crashes
> 
> Victor Goldenshtein (2):
>   wlcore: remove unnecessary WARN_ON in wl12xx_tx_reset
>   wlcore: restore default channel configuration
> 
> Yair Shapira (1):
>   wl18xx: support 2nd set of mac/phy tx-power params

Applied the whole series, except for 10/20 (still trying to get more
information about it).  Some changes as discussed in the respective
threads.

Thanks Arik!

--
Luca.

