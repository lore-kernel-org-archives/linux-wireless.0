Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40000 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbKFFqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 00:46:11 -0500
Message-ID: <563C3E8A.8050904@qti.qualcomm.com> (sfid-20151106_064614_854885_5AD7F1A7)
Date: Fri, 6 Nov 2015 11:15:46 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] Fix few WMI/HTT interfaces
References: <1446638737-7953-1-git-send-email-vthiagar@qti.qualcomm.com>	<87h9l1bq7o.fsf@kamboji.qca.qualcomm.com>	<20151105045754.GA12919@qca.qualcomm.com> <87d1vobte4.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d1vobte4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 November 2015 04:33 PM, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:
>
>> On Wed, Nov 04, 2015 at 07:59:39PM +0200, Kalle Valo wrote:
>>> Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:
>>>
>>>> This patch set fixes mismatch in peer_assoc complete wmi command for
>>>> version 10.4 and peer_id configuration for HTT version < 3.4.
>>>>
>>>> V2:
>>>> 	- Add cover letter
>>>> 	- Rename ath10k_mac_need_offchan_tx_work() to
>>>> 	  ath10k_mac_tx_frm_has_freq(). Add htt-op-version check
>>>> 	  to the helper and use it in ath10k_htt_tx() while configuring
>>>> 	  peerid.
>>>>
>>>> Vasanthakumar Thiagarajan (3):
>>>>    ath10k: Fix peer assoc complete WMI command for 10.4
>>>>    ath10k: Rename the helper which is used for off-channel tx
>>>>    ath10k: Fix peerid configuration in htt tx desc for htt version < 3.4
>>>
>>> These had a conflict but you didn't use ath.git as the baseline so I
>>> can't easily fix them. Please try always to use clean ath.git master
>>> branch as the baseline for your patches.
>>>
>>> Applying: ath10k: Fix peer assoc complete WMI command for 10.4
>>> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/wmi.h).
>>> Repository lacks necessary blobs to fall back on 3-way merge.
>>> Cannot fall back to three-way merge.
>>> Patch failed at 0001 ath10k: Fix peer assoc complete WMI command for 10.4
>>
>> Sorry for this. I prepared these patches on ath:master on top of my other pending
>> patch set. Not sure what went wrong.
>
> If you have two patchsets you shouldn't have them on the same branch,
> unless they have a strict dependency with each other of course. I prefer
> that you have two separate topic branches which both use the master
> branch as the baseline as then it's easiest for me to handle conflicts
> etc.
>

Sure, thanks.

Vasanth
