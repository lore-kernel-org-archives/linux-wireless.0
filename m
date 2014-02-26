Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41326 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBZRvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 12:51:47 -0500
Message-ID: <530E2999.6000901@candelatech.com> (sfid-20140226_185154_830014_15ECC707)
Date: Wed, 26 Feb 2014 09:51:21 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:  make TARGET_NUM_PEERS match WMI_MAX_KEY_INDEX.
References: <1392742567-6134-1-git-send-email-greearb@candelatech.com> <87r46plt07.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87r46plt07.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2014 08:48 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This appears to fix the problem of running out of keys
>> in the firmware.  Possibly it only hides the problem,
>> however.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> IIRC you asked me to drop this patch in other thread. I have now done
> that.

Yes, it breaks upstream firmware (looks like it asserts, but not sure exactly
why).

I still think it might be a problem, but it would take someone with newer
firmware source and/or better understanding of how the keys are supposed
to work to know for sure.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

