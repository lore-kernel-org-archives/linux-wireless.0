Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59896 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKYQWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 11:22:24 -0500
Message-ID: <5474ACBF.7090905@candelatech.com> (sfid-20141125_172315_312768_F10144C2)
Date: Tue, 25 Nov 2014 08:22:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/2] ath10k: move create-ht-cap methods above set-antenna.
References: <1411576506-11815-1-git-send-email-greearb@candelatech.com> <874mtn3dof.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <874mtn3dof.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2014 12:08 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
>> From: Ben Greear <greearb@candelatech.com>
>>
>> We will need to use these in set-antenna, so move them
>> so that we do not have to define the method signatures.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> I'm dropping these two patches. Please resend once we figure out how to
> handle the band updated.

It might be a while...I'm working on some other tasks these days
and don't have time to respin ath10k patches at the moment.

If someone else wants to work on getting them upstream, please be
my guest.

Per Felix's comment, maybe my patches were actually OK as they are....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

