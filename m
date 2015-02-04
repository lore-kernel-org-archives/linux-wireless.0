Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58269 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161422AbbBDPah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 10:30:37 -0500
Message-ID: <54D23B64.3060806@candelatech.com> (sfid-20150204_163055_207679_00949B3E)
Date: Wed, 04 Feb 2015 07:31:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/8] ath10k: scan should handle scan-start-failed event
 properly.
References: <1421087564-10384-1-git-send-email-greearb@candelatech.com> <878ugeul6u.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878ugeul6u.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2015 12:37 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> In case firmware fails to start the scan, then complete
>> the start condition and clean up so that driver does not
>> block on timeout.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> These patches are now in the pending branch.
>
> 86f50c71b224 ath10k: scan should handle scan-start-failed event properly
> c6dde373a4bb ath10k: fix spelling mistakes and add details to mac logging
> 198c0184d94c ath10k: fix spelling in htt code comment
> 227822d52d26 ath10k: fix CE_DESC_FLAGS_META_DATA_LSB definition
>
> I dropped the rest as I really would like to avoid maintaining yet
> another firmware branch.


Thanks for applying those.

I'll stop sending patches related to my firmware.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

