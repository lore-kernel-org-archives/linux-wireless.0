Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47800 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAQPPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 10:15:09 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add support for AP CSA
References: <1389345563-3445-1-git-send-email-michal.kazior@tieto.com>
	<87lhyercjd.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQktbmjYJA91mJ_EU=iTtCOFiPNPjjxRm=yxiwxposS-rA@mail.gmail.com>
Date: Fri, 17 Jan 2014 17:15:03 +0200
In-Reply-To: <CA+BoTQktbmjYJA91mJ_EU=iTtCOFiPNPjjxRm=yxiwxposS-rA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 17 Jan 2014 14:46:39 +0100")
Message-ID: <878uuer66g.fsf@kamboji.qca.qualcomm.com> (sfid-20140117_161517_045944_7D461EB6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 17 January 2014 13:57, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This patch implements Channel Switch Announcement
>>> for AP mode. This allows for a smooth channel
>>> switch for connected stations that support CSA
>>> when radar is detected.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> [...]
>>
>>> --- a/drivers/net/wireless/ath/ath10k/core.h
>>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>>> @@ -414,6 +414,7 @@ struct ath10k {
>>>       unsigned int filter_flags;
>>>       unsigned long dev_flags;
>>>       u32 dfs_block_radar_events;
>>> +     struct ath10k_vif *csa_arvif;
>>
>> Please document how this is serialised.
>
> [...]
>
> I have a local patch capable of multi-interface CSA which basically
> rewrites this patch entirely. Unless you want me send that as a follow
> up patch later I'd like to drop this patch and send a completely new
> one later.

Yeah, let's then just drop this patch.

-- 
Kalle Valo
