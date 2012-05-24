Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13865 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2EXH1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 03:27:00 -0400
Message-ID: <4FBDE2BF.5050901@qca.qualcomm.com> (sfid-20120524_092704_341675_1AD279FA)
Date: Thu, 24 May 2012 10:26:55 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: Add support for setting tx rateset.
References: <1337673192-3469-1-git-send-email-bkamatch@qca.qualcomm.com> <4FBDE27A.2050900@qca.qualcomm.com>
In-Reply-To: <4FBDE27A.2050900@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2012 10:25 AM, Kalle Valo wrote:
> On 05/22/2012 10:53 AM, Bala Shanmugam wrote:
>> Tx legacy and mcs rateset can configured using iw for
>> 2.4 and 5 bands.  Add support for the same in driver.
>>
>> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> 
> Thanks, this looks very good now. I did two minor changes still:
> 
>     kvalo: add an enum for the hw flags and rename the flag accordingly,
>     rename ath6kl_cfg80211_set_bitrate_mask() to a shorter version to make
>     it easier to indent
> 
> The enum looks like this:
> 
> enum ath6kl_hw_flags {
> 	ATH6KL_HW_FLAG_64BIT_RATES	= BIT(0),
> };
> 
> And I did that just to make it more obvious to group the flags in the
> future.

Oops, I forgot to mention that the patch is now applied to ath6kl.git.
Thanks.

Kalle
