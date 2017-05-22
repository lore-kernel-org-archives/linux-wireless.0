Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53042 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752309AbdEVQRB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 12:17:01 -0400
Subject: Re: ath10k: Initialize nbytes to 0
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <1483653641-8377-1-git-send-email-greearb@candelatech.com>
 <0fa10cfb9e514244a0c39fa2688574e4@euamsexm01a.eu.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <ad091f4e-b315-3cf7-c3aa-a0fddfe8c1c3@candelatech.com> (sfid-20170522_181705_590601_5FB6D40C)
Date: Mon, 22 May 2017 09:17:00 -0700
MIME-Version: 1.0
In-Reply-To: <0fa10cfb9e514244a0c39fa2688574e4@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2017 07:53 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> ath10k firmware checks nbytes == 0 as part of determining if DMA
>> has completed successfully.  To help make this work more often,
>> have the driver initialize nbytes to zero when freeing the descriptor
>> slot.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> This patch was in linux-wireless patchwork instance but not in ath10k instance,
> which means that the patch was not delivered to ath10k list. I guesss mailing
> list problems?
>
> But anyway, I didn't see any comments. Is this still valid?

 From my reading of the firmware, it appears the patch is a good idea.
It at least does not seem to make anything worse as it has not
been implicated in any problems in our testing and it has been in our kernel
since I posted the patch.

So, I think it should be applied.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
