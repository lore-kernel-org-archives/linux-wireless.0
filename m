Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42766 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbaDBHdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 03:33:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] ath10k:  add helper method to grab debug stats.
References: <1396374940-21453-1-git-send-email-greearb@candelatech.com>
Date: Wed, 2 Apr 2014 10:32:55 +0300
In-Reply-To: <1396374940-21453-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 1 Apr 2014 10:55:40
	-0700")
Message-ID: <8738hwrxso.fsf@kamboji.qca.qualcomm.com> (sfid-20140402_093305_154384_34CFC69E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> It can be nice to update the firmware's stats while
> debugging other bits of the driver, so add helper method
> to do this.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -135,4 +135,6 @@ struct dbglog_hdr_s {
>  
>  void ath10k_dbg_print_fw_dbg_buffer(u8 *buffer, int len, const char* lvl);
>  
> +int ath10k_refresh_peer_stats(struct ath10k *ar);

I don't see anyone calling this. How are you planning to use it?

-- 
Kalle Valo
