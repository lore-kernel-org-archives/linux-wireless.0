Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:48234 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2I1JAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 05:00:18 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh01.mail.saunalahti.fi (Postfix) with SMTP id 3A5589002B
	for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2012 12:00:16 +0300 (EEST)
Received: from [192.168.100.26] (a88-113-65-16.elisa-laajakaista.fi [88.113.65.16])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 1CB7A40A6
	for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2012 12:00:15 +0300 (EEST)
Message-ID: <1348822793.15949.7.camel@cumari.coelho.fi> (sfid-20120928_110024_697534_4853CF16)
Subject: Re: [PATCH 00/31] wlcore/wl18xx/wl12xx patches for 3.7
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Date: Fri, 28 Sep 2012 11:59:53 +0300
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 13:37 +0300, Luciano Coelho wrote:
> Hi,
> 
> This is a bunch of patches that have accumulated in our internal tree
> and are intended for 3.7.  Mostly bug-fixes and small improvements all
> over.
> 
> Cheers,
> Luca.
> 
> Arik Nemtsov (9):
>   wlcore: AP mode - send non-data packets with basic rates
>   wlcore: allow only the lowest OFDM rate for p2p setup frames
>   wlcore: make Tx flush timings more verbose
>   wlcore: tx_flush - optimize flow and force Tx during the flush
>   wlcore/wl18xx/wl12xx: allow up to 3 mac addresses
>   wlcore: make debug prints work without dynamic debug
>   wlcore: allow up to 3 running STA interfaces in combinations
>   wlcore: spi: use private max-buf-size limit
>   wl18xx: default to siso40 in 2.4ghz with a single antenna
> 
> Eliad Peller (9):
>   wlcore: consider single fw case
>   wlcore: cancel recovery_work on stop() instead of remove_interface()
>   wlcore: resume() only if sta is associated
>   wlcore: always use wlvif->role_id for scans
>   wlcore: lazy-enable device roles
>   wlcore: invalidate keep-alive template on disconnection
>   wlcore: use dynamic keep-alive template ids
>   wlcore: decrease elp timeout
>   wlcore: protect wlcore_op_set_key with mutex
> 
> Eyal Shapira (1):
>   wlcore: configure wowlan regardless of wakeup conditions
> 
> Ido Reis (2):
>   wl18xx: update default phy configuration for pg2
>   wl18xx: increase rx_ba_win_size to 32
> 
> Ido Yariv (6):
>   wlcore: Prevent interaction with HW after recovery is queued
>   wlcore: Don't recover during boot
>   wlcore: Fix unbalanced interrupts enablement
>   wlcore: Allow memory access when the FW crashes
>   wlcore: Refactor probe
>   wlcore: Load the NVS file asynchronously
> 
> Igal Chernobelsky (2):
>   wl18xx/wl12xx: defines for Tx/Rx descriptors num
>   wlcore/wl18xx/wl12xx: aggregation buffer size set
> 
> Yair Shapira (2):
>   wl18xx: number_of_assembled_ant5 indicates if A band is enabled
>   wlcore/wl18xx: add phy_fw_version_str to debugfs driver_state

Applied the series.  Thanks to all the contributers!

--
Luca.

