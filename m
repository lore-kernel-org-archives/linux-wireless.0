Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbbE1JZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 05:25:10 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull request: iwlwifi-next 2015-05-26
Date: Thu, 28 May 2015 09:25:05 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B7583B6@hasmsx107.ger.corp.intel.com> (sfid-20150528_112516_070185_B8F06834)
References: <1432667798.26624.3.camel@intel.com>
 <87lhg9xe0c.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lhg9xe0c.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:
> 
> > this is a pull request for 4.2. Nothing really stands out besides what
> > I wrote in the tag. Even the diffstat hints what is the biggest part
> > of this pull request :)
> 
> I see there was a minor comment to one of the patches. Can I still pull this or
> what are you planning to do?

I wasn't planning to fix that typo but...

> 
> > Note that there are fixes here that didn't make it to my previous pull
> > request for 4.1. I tagged them for stable since the wording of your
> > last pull request for 4.1 to Dave hinted me that you won't send any
> > pull request for 4.1 to him anymore.
> 
> Yeah, I said that hopefully it's the last pull request. I got one important fix
> from Arend so I will try to send one more, but let's see how it goes.
> 
... if that's the case, do you want me to split the patches differently and add the ones I CCed to stable to iwlwifi-fixes?
If I re-spin iwlwifi-next anyway, I'll fix the typo above.
