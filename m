Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27185 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934731AbdEVOxP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 10:53:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Initialize nbytes to 0
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1483653641-8377-1-git-send-email-greearb@candelatech.com>
References: <1483653641-8377-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>
Message-ID: <0fa10cfb9e514244a0c39fa2688574e4@euamsexm01a.eu.qualcomm.com> (sfid-20170522_165419_960165_3BEE6316)
Date: Mon, 22 May 2017 16:53:06 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> ath10k firmware checks nbytes == 0 as part of determining if DMA
> has completed successfully.  To help make this work more often,
> have the driver initialize nbytes to zero when freeing the descriptor
> slot.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

This patch was in linux-wireless patchwork instance but not in ath10k instance,
which means that the patch was not delivered to ath10k list. I guesss mailing
list problems?

But anyway, I didn't see any comments. Is this still valid?

-- 
https://patchwork.kernel.org/patch/9499733/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
