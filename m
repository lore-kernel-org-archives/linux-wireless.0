Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38177 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbbJ2Q0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 12:26:14 -0400
Subject: Re: [PATCH-v2 1/2] ath6k: break stats gathering code into separate
 method.
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <1445530059-6276-1-git-send-email-greearb@candelatech.com>
 <87eggesqk5.fsf@kamboji.qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <563248A5.7080505@candelatech.com> (sfid-20151029_172620_468023_B1DB7A14)
Date: Thu, 29 Oct 2015 09:26:13 -0700
MIME-Version: 1.0
In-Reply-To: <87eggesqk5.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2015 01:09 PM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This will allow us to call it from elsewhere when implementing
>> ethtool stats.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> I'll do s/ath6k/ath6kl/ (manually) for both patches.

Thank you for fixing & applying the patches.

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

