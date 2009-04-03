Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2891 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761739AbZDCMXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 08:23:54 -0400
Date: Fri, 3 Apr 2009 08:23:32 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Trouble Associating with ath5k on AR5212
Message-ID: <20090403122332.GA14853@hash.localnet> (sfid-20090403_142400_382165_5320D7D9)
References: <49D4C7B3.7010803@gmail.com> <b6c5339f0904020805w5e210c2bl542eadb20ac5d6c7@mail.gmail.com> <49D56445.20502@gmail.com> <20090403020358.GA12406@hash.localnet> <49D571BB.7060406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49D571BB.7060406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 02, 2009 at 10:17:31PM -0400, Will Keaney wrote:
> dmesg shows this:
> [38645.639170] ath5k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->
> IRQ 17
> [38645.639199] ath5k 0000:03:00.0: setting latency timer to 64
> [38645.639342] ath5k 0000:03:00.0: registered as 'phy5'
> [38645.872038] phy5: Selected rate control algorithm 'minstrel'
> [38645.882037] Registered led device: ath5k-phy5::rx
> [38645.882090] Registered led device: ath5k-phy5::tx
> [38645.882097] ath5k phy5: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
> [38646.133614] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [38667.211026] ath5k phy5: noise floor calibration timeout (5785MHz)
> 
> I think the key there is the last line.  There is no further output in
> dmesg, regardless of what I do in wpa_supplicant.

Probably a red herring, actually -- but yeah, you should be seeing more
output as the association process continues.  That is a pretty frequent
and harmless error message, here you are scanning and just changed to
a 5.7 ghz channel for a passive scan.

Are you getting any results at all from scans?  Is ath5k using 100% of
any cpu?

-- 
Bob Copeland %% www.bobcopeland.com

