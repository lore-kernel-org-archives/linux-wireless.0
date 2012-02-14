Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab2BNN5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 08:57:10 -0500
Message-ID: <4F3A6828.7060001@qca.qualcomm.com> (sfid-20120214_145714_357145_43CF0E06)
Date: Tue, 14 Feb 2012 19:26:56 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix memory leak of rx packets in endpoint
 0
References: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com> <1328886633-2823-2-git-send-email-vthiagar@qca.qualcomm.com> <4F3A0C07.5030508@qca.qualcomm.com> <4F3A0CE5.2090206@qca.qualcomm.com>
In-Reply-To: <4F3A0CE5.2090206@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 February 2012 12:57 PM, Vasanthakumar Thiagarajan wrote:
> On Tuesday 14 February 2012 12:53 PM, Raja Mani wrote:
>>
>> Vasanth,
>>
>> My system is freezing with this patch when i tried to unload
>> ath6kl_sdio.ko. Could you double check this change once again?
>
> Thanks for reporting this. Kalle, please drop this, i'll send the
> revised patch.
>
Actually the first patch also needs to be applied to avoid invalid memory
free.

Kalle, when used with PATCH[1/2] this patch does not cause any
system freeze. This patch can be taken if there is no any review commands.

-- 
Vasanth

