Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36915 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbbAWR2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:28:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>
Subject: Re: [1/8] mwifiex: remove redundant nick_name variable
References: <20150123172247.812AD141654@smtp.codeaurora.org>
Date: Fri, 23 Jan 2015 19:28:12 +0200
In-Reply-To: <20150123172247.812AD141654@smtp.codeaurora.org> (Kalle Valo's
	message of "Fri, 23 Jan 2015 17:22:47 +0000 (UTC)")
Message-ID: <87lhktl843.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_182822_205730_17EB6CAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> This is not used anywhere execpt initialization.
>> 
>> Signed-off-by: Avinash Patil <patila@marvell.com>
>> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> Signed-off-by: Cathy Luo <cluo@marvell.com>
>
> Thanks, 6 patches applied to wireless-drivers-next.git:
>
> 5e7f03b102eb mwifiex: remove redundant nick_name variable
> 534cfed66caf mwifiex: set wiphy params only once
> bb2703cffb2f mwifiex: do not declare wdev as pointer
> 7d2d4fbf4e8e mwifiex: add init parameter to init command routine
> 16b21941fa9a mwifiex: handle PS events on AP interface as well
> 770c385d2744 mwifiex: support conversion to any virtual interface type
>
> 2 patches failed to apply:
>
> Applying: mwifiex: store permanant mac address in adapter structure
> error: patch failed: drivers/net/wireless/mwifiex/init.c:285
> error: drivers/net/wireless/mwifiex/init.c: patch does not apply
> Patch failed at 0001 mwifiex: store permanant mac address in adapter structure
>
> Applying: mwifiex: manage virtual interface limits efficiently
> error: patch failed: drivers/net/wireless/mwifiex/init.c:286
> error: drivers/net/wireless/mwifiex/init.c: patch does not apply
> Patch failed at 0001 mwifiex: manage virtual interface limits efficiently

But mwifiex doesn't compile any more so I had to drop all patches.
Please resend the whole series.

-- 
Kalle Valo
