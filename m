Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43452 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbCXIuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 04:50:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v4 5/6] ath10k: add wmi support for tdls
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-6-git-send-email-marek.puzyniak@tieto.com>
	<87pp7zd81d.fsf@kamboji.qca.qualcomm.com>
	<CADnKcVizKNOJwhc9a=XfPUZfEM3V+QJ59sK0oorWK-b3jeKRyA@mail.gmail.com>
Date: Tue, 24 Mar 2015 10:50:28 +0200
In-Reply-To: <CADnKcVizKNOJwhc9a=XfPUZfEM3V+QJ59sK0oorWK-b3jeKRyA@mail.gmail.com>
	(Marek Puzyniak's message of "Tue, 24 Mar 2015 03:33:28 -0400")
Message-ID: <874mpadbjf.fsf@kamboji.qca.qualcomm.com> (sfid-20150324_095043_860317_30756441)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> On 23 March 2015 at 11:53, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Marek Puzyniak <marek.puzyniak@tieto.com> writes:
>>
>>> As a part of tdls implementation introduce
>>> tdls related wmi data structures, constant
>>> values and functions.
>>>
>>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>>
>> This patch had non-trivial conflicts, please check carefully my
>> resolution in the pending branch.
>>
>>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.h
>>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.h
>>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
>>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
>>
>> --
>> Kalle Valo
>
> It looks OK, but there is one small thing in file
> drivers/net/wireless/ath/ath10k/wmi-tlv.c.
> There are two new lines between functions ath10k_wmi_tlv_op_gen_tdls_peer_update
> and ath10k_wmi_tlv_op_gen_wow_enable.

Thanks, fixed now.

-- 
Kalle Valo
