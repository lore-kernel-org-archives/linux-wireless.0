Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60594 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752272AbdLBVlR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 16:41:17 -0500
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
 <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
 <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
 <e98b52a7-ac14-81da-1fab-0c66befcf6d2@candelatech.com>
 <878telw65j.fsf@kamboji.qca.qualcomm.com>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <73dae55c-4feb-b573-9d02-4942b201bec8@candelatech.com> (sfid-20171202_224122_067121_BB795EE5)
Date: Sat, 2 Dec 2017 13:41:07 -0800
MIME-Version: 1.0
In-Reply-To: <878telw65j.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/02/2017 06:34 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> Is this patch destined for stable?
>>
>> I was expecting to see it show up in the older stable releases,
>> but it has not so far as far as I can tell.
>
> We are working on it, but not sure yet to which releases, it doesn't
> directly apply to all active stable releases.

I had no luck trying to apply it to a 3.17-ish ath10k.  Gave up after
a bit and tried backporting the whole stack instead :P

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
