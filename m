Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60508 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaBZS3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 13:29:13 -0500
Message-ID: <530E325E.4060503@candelatech.com> (sfid-20140226_192916_634758_664A2E0D)
Date: Wed, 26 Feb 2014 10:28:46 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k:  add vdev-id, return code to error codes
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com> <87bnya6xey.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bnya6xey.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2014 10:06 PM, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
>> From: Ben Greear <greearb@candelatech.com>
>>
>> When using multiple vdevs (stations, aps, etc), it is
>> nice to be able to associate log messages with specific
>> interfaces.  So, add vdev-id to most logging messages.
>> Add return code as well, where it was missing.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> I did some changes just to have consistent style for warning messages,
> see my incremental diff patch below. Let me know if you agree with my
> changes, the full patch is in ath-next-test branch.

Hello!

Are you wanting me to send in a revised version of this patch, or
is it fine as previously posted?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

