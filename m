Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55286 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764235AbcINPOx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:14:53 -0400
Message-ID: <57D9696B.10103@candelatech.com> (sfid-20160914_171516_931117_F415583F)
Date: Wed, 14 Sep 2016 08:14:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 10/21] ath10k: support logging ath10k_info as KERN_DEBUG
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>        <1462986153-16318-11-git-send-email-greearb@candelatech.com> <87k2eeef79.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k2eeef79.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/14/2016 07:19 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Helps keep messages off of (serial) console when
>> that is desired.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> Isn't /proc/sys/kernel/print exactly for this purpose? At least I recall
> using it.

I just wanted to hide some ath10k logs from the console, not all system logs.  I don't think
that /proc/sys/kernel/print has any granularity?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
