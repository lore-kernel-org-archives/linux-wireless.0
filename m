Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34077 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbcAHImf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2016 03:42:35 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2016-01-07
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9844E2@hasmsx107.ger.corp.intel.com>
	<87oacxjdxj.fsf@kamboji.qca.qualcomm.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E984F12@hasmsx107.ger.corp.intel.com>
Date: Fri, 08 Jan 2016 10:42:28 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E984F12@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Fri, 8 Jan 2016 08:12:02 +0000")
Message-ID: <87fuy8jwcr.fsf@kamboji.qca.qualcomm.com> (sfid-20160108_094239_315929_AEB7C571)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> On 01/07/2016 11:08 PM, Kalle Valo wrote:
>> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
>>
>>> Me again,
>>>
>>> On 01/07/2016 02:46 PM, Grumbach, Emmanuel wrote:
>>>> Hi Kalle,
>>>>
>>>> Here is the last round of patches for 4.5. Most of them are small and / or fixes.
>>>> Let me know if you have issues.
>>>> FYI - I scripted a few checks so that I hope that the internal tags that leaked
>>>> in the previous pull request won't leak any more.
>>>>
>>>> The following changes since commit e5d15cb530082cc13a6c9457eddd6f75b0f4de65:
>>> I had to edit one commit. I re-pushed to the same tag and added another
>>> _2 tag if you prefer to be sure.
>> Heh, you sent this just in the last minute (if Linus releases 4.4 this
>> weekend as planned). I pulled iwlwifi-next-for-kalle-2016-01-07_2 now,
>> thanks.
>
> Right, OTOH, most of the patches here are really fixes.

Sure. I meant about sending these patches via wireless-drivers-next
which I'm just about to close. I'll "open" both wireless-drivers trees
again once -rc1 is released.

-- 
Kalle Valo
