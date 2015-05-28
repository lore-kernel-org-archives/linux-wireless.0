Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:48605 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbbE1KZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 06:25:18 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull request: iwlwifi-next 2015-05-26
Date: Thu, 28 May 2015 10:25:07 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B75889A@hasmsx107.ger.corp.intel.com> (sfid-20150528_122522_413707_2FE06121)
References: <1432667798.26624.3.camel@intel.com>
	<87lhg9xe0c.fsf@kamboji.qca.qualcomm.com>
	<0BA3FCBA62E2DC44AF3030971E174FB31B7583B6@hasmsx107.ger.corp.intel.com>
 <87egm1xauk.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87egm1xauk.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
> 
> >> > Note that there are fixes here that didn't make it to my previous
> >> > pull request for 4.1. I tagged them for stable since the wording of
> >> > your last pull request for 4.1 to Dave hinted me that you won't
> >> > send any pull request for 4.1 to him anymore.
> >>
> >> Yeah, I said that hopefully it's the last pull request. I got one
> >> important fix from Arend so I will try to send one more, but let's see how
> it goes.
> >>
> > ... if that's the case, do you want me to split the patches
> > differently and add the ones I CCed to stable to iwlwifi-fixes?
> 
> Sure, go ahead if you want to do that. But please keep in mind that the bar is
> higher when we go closer to the actual release. I found two patches from the
> patchset with CC stable (I hope I didn't miss
> anything):
> 
> [PATCH 03/39] iwlwifi: pcie: fix tracking of cmd_in_flight [PATCH 32/39]
> iwlwifi: nvm: fix otp parsing in 8000 hw family
> 
> In my opinion these two are ok.
> 

Cool. I'll respin.

> > If I re-spin iwlwifi-next anyway, I'll fix the typo above.
> 
> Ok, I don't care about the typo in the commit log, we do those all the time :) I
> just wanted to check that I don't pull anything which I'm not supposed to
> pull.
> 
> 
> --
> Kalle Valo
