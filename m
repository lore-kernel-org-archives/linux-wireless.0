Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33352 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbE1KUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 06:20:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2015-05-26
References: <1432667798.26624.3.camel@intel.com>
	<87lhg9xe0c.fsf@kamboji.qca.qualcomm.com>
	<0BA3FCBA62E2DC44AF3030971E174FB31B7583B6@hasmsx107.ger.corp.intel.com>
Date: Thu, 28 May 2015 13:20:03 +0300
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B7583B6@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Thu, 28 May 2015 09:25:05 +0000")
Message-ID: <87egm1xauk.fsf@kamboji.qca.qualcomm.com> (sfid-20150528_122016_125438_59D5106A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

>> > Note that there are fixes here that didn't make it to my previous pull
>> > request for 4.1. I tagged them for stable since the wording of your
>> > last pull request for 4.1 to Dave hinted me that you won't send any
>> > pull request for 4.1 to him anymore.
>> 
>> Yeah, I said that hopefully it's the last pull request. I got one important fix
>> from Arend so I will try to send one more, but let's see how it goes.
>> 
> ... if that's the case, do you want me to split the patches
> differently and add the ones I CCed to stable to iwlwifi-fixes?

Sure, go ahead if you want to do that. But please keep in mind that the
bar is higher when we go closer to the actual release. I found two
patches from the patchset with CC stable (I hope I didn't miss
anything):

[PATCH 03/39] iwlwifi: pcie: fix tracking of cmd_in_flight
[PATCH 32/39] iwlwifi: nvm: fix otp parsing in 8000 hw family

In my opinion these two are ok.

> If I re-spin iwlwifi-next anyway, I'll fix the typo above.

Ok, I don't care about the typo in the commit log, we do those all the
time :) I just wanted to check that I don't pull anything which I'm not
supposed to pull.


-- 
Kalle Valo
