Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54036 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdFAM6U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 08:58:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Initialize nbytes to 0
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1483653641-8377-1-git-send-email-greearb@candelatech.com>
References: <1483653641-8377-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>
Message-ID: <b2a323bda04b475983a58e4c7113a81a@eusanexr01a.eu.qualcomm.com> (sfid-20170601_145832_686245_5E3ACBD0)
Date: Thu, 1 Jun 2017 05:58:16 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:

> ath10k firmware checks nbytes == 0 as part of determining if DMA
> has completed successfully.  To help make this work more often,
> have the driver initialize nbytes to zero when freeing the descriptor
> slot.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

4f40b423339b ath10k: initialize nbytes to 0

-- 
https://patchwork.kernel.org/patch/9499733/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
