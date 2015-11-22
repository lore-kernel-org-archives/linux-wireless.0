Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33951 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbKVRXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 12:23:44 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH v2 06/27] brcm80211: move under broadcom vendor directory
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
	<1447857966-19560-7-git-send-email-kvalo@codeaurora.org>
	<564CCF2A.4030203@hauke-m.de>
	<871tbmwhsk.fsf@kamboji.qca.qualcomm.com>
	<564F966A.7080300@broadcom.com>
Date: Sun, 22 Nov 2015 19:23:37 +0200
In-Reply-To: <564F966A.7080300@broadcom.com> (Arend van Spriel's message of
	"Fri, 20 Nov 2015 22:53:46 +0100")
Message-ID: <87lh9qrlra.fsf@kamboji.qca.qualcomm.com> (sfid-20151122_182402_381181_B09B9A75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 11/19/2015 08:48 AM, Kalle Valo wrote:
>> Hauke Mehrtens <hauke@hauke-m.de> writes:
>>
>>> On 11/18/2015 03:45 PM, Kalle Valo wrote:
>>>> Part of reorganising wireless drivers directory and Kconfig. Note that I had to
>>>> edit Makefiles from subdirectories to use the new location.
>>>>
>>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>>> ---
>>>
>>> I would prefer to remove the brcm80211 directory in this process and create:
>>> drivers/net/wireless/broadcom/brcmfmac
>>> drivers/net/wireless/broadcom/brcmsmac
>>> drivers/net/wireless/broadcom/brcmutil
>>> drivers/net/wireless/broadcom/include
>>>
>>> This way we have one directory less.
>>
>> I think this could be done separately. This patchset is big enough
>> already, I would not like to make it anymore complicated.
>>
>> And I actually like the brcm80211 directory, I would not mind keeping it
>> still.
>
> I prefer to keep it as brcmsmac and brcmfmac rely on brcmutil module
> so I want to keep them together under brcm80211.
>
> So does this patch go in before or after the patches I submitted
> before the merge window. I hope after :-p

Sorry, the vendor patches go in first :) It's much safer that way.

But I think that git should be smart enough and your patchset from
before the merge window should still apply without issues.

-- 
Kalle Valo
