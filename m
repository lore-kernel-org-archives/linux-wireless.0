Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32994 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbLAT3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 14:29:08 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ben Ami\, Golan" <golan.ben.ami@intel.com>
Subject: Re: [PATCH 24/41] iwlwifi: mvm: move fw-dbg code to separate file
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
	<1448963947-24302-24-git-send-email-emmanuel.grumbach@intel.com>
	<87r3j6gfws.fsf@kamboji.qca.qualcomm.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E90714D@hasmsx107.ger.corp.intel.com>
	<CANUX_P0Y5nDACtND_WaQfXBQq2AyLbxxdOX-S5NfQODzdiaK3g@mail.gmail.com>
Date: Tue, 01 Dec 2015 21:29:03 +0200
In-Reply-To: <CANUX_P0Y5nDACtND_WaQfXBQq2AyLbxxdOX-S5NfQODzdiaK3g@mail.gmail.com>
	(Emmanuel Grumbach's message of "Tue, 1 Dec 2015 21:26:20 +0200")
Message-ID: <87mvtuge80.fsf@kamboji.qca.qualcomm.com> (sfid-20151201_202912_157694_0BE383A6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@gmail.com> writes:

> On Tue, Dec 1, 2015 at 9:14 PM, Grumbach, Emmanuel
> <emmanuel.grumbach@intel.com> wrote:
>>
>>
>> On 12/01/2015 08:53 PM, Kalle Valo wrote:
>>> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>>>
>>>> From: Golan Ben-Ami <golan.ben.ami@intel.com>
>>>>
>>>> The fw debug functionality is big enough to warrant
>>>> a separate file. Move existing related functions to the new file.
>>>>
>>>> Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
>>>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>> [...]
>>>
>>>>  intc-scripts/publishable-files                     | 203 ++++++
>>> Added by accident?
>>>
>
> Somehow this file didn't appear in the pull request message. I would
> have caught there I believe.

It wasn't visible in the pull request as a later patch removed the same
file.

-- 
Kalle Valo
