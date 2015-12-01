Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36247 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbbLAT0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 14:26:22 -0500
Received: by lfs39 with SMTP id 39so20063642lfs.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 11:26:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E90714D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
	<1448963947-24302-24-git-send-email-emmanuel.grumbach@intel.com>
	<87r3j6gfws.fsf@kamboji.qca.qualcomm.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E90714D@hasmsx107.ger.corp.intel.com>
Date: Tue, 1 Dec 2015 21:26:20 +0200
Message-ID: <CANUX_P0Y5nDACtND_WaQfXBQq2AyLbxxdOX-S5NfQODzdiaK3g@mail.gmail.com> (sfid-20151201_202625_413035_D08BA4A6)
Subject: Re: [PATCH 24/41] iwlwifi: mvm: move fw-dbg code to separate file
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ben Ami, Golan" <golan.ben.ami@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 1, 2015 at 9:14 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>
>
> On 12/01/2015 08:53 PM, Kalle Valo wrote:
>> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>>
>>> From: Golan Ben-Ami <golan.ben.ami@intel.com>
>>>
>>> The fw debug functionality is big enough to warrant
>>> a separate file. Move existing related functions to the new file.
>>>
>>> Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
>>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> [...]
>>
>>>  intc-scripts/publishable-files                     | 203 ++++++
>> Added by accident?
>>
Somehow this file didn't appear in the pull request message. I would
have caught there I believe.

> Indeed... Thanks for catching this...
> Will re-spin...

 I pushed -f the tree with the same tag. Should be fine now. Thanks again.
