Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:30388 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbYH0Ppi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 11:45:38 -0400
Received: by ug-out-1314.google.com with SMTP id c2so947702ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2008 08:45:37 -0700 (PDT)
Message-ID: <1ba2fa240808270845k6000cb68o382111122ad3d069@mail.gmail.com> (sfid-20080827_174545_676778_59EEF026)
Date: Wed, 27 Aug 2008 18:45:36 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"David Miller" <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <200808271722.55627.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080827013009.GA15781@tuxdriver.com>
	 <200808271510.35950.mb@bu3sch.de>
	 <1ba2fa240808270755t2f3d0c28rcb874011f5540ef3@mail.gmail.com>
	 <200808271722.55627.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2008 at 6:22 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Wednesday 27 August 2008 16:55:15 Tomas Winkler wrote:
>> I'm not sure what you are taking about, we did post patches to
>> wireless-testing, the driver for 5000 HW  is working in 2.6.27-rc4 I
>> personally use it every day.  I'm sending bug fixes, like this seris
>> of patches is direct answer to bugs that were discovered very
>> recently, I'm not sure what's everybody problem here.
>
> The problem is that these patches are posted in huge batches.
> There are three problems (probably more) with that:
> 1) "Oh, one of these 15 patches recently merged broke my hw"
>   instead of
>   "This patch XXX recently merged broke my hw"
> 2) It's a _lot_ harder to review. I do not have the time to review
>   a lot of patches at once. I bet other people won't either.
> 3) If somebody has any objections against one patch, you'll probably
>   have to rebase them all (See recent pull request vs cleanups).
>   That's additional work for you.
>
> What's the problem with sending patches upstream as soon as you finished
> them, instead of piling them up locally and sending them alltogether?

First of all, mac patches are send immediately to wireless-dev for
review just because we don't want to break anyone works (just look at
the archives).  iwlwifi patches are sent first to internal mailing
list for review and internal testing because nobody is really
reviewing these patches in wireless-dev and this is common practices
(see latest orinoco 19 patches dump) Internal mailing list is
really the only place I'm getting any feedback on iwlwifi code, they
are few exception of course.
Second I'm not sure why Yi is sending them only once a week I thought
he had some agreement with John, really don't know.

>> We fixed bugs in wireless-testing/mac80211 that were there for months
>> just because we are only one that do any comprehensive validation. I
>> don't  want insult anyone and I really exaggeration here but
>> sometimes I have feeling that more people are breaking the code.
>
> If you work directly upstream, you will discover these bugs even faster.
> If you maintain your local fork of mac80211, you will have a delay. But
> you will have to handle them _anyway_. It's just delayed.

For exact reason we delay patches to 2.6.28, too keep stable.

>
> And please, don't act like you don't add bugs to mac80211. There were several
> bugs that broke connections on b43 (and probably other hw, too) in the past.

Not sure what exact patches are you referring to but I do a lot of
bugs no doubt and I really test only iwlwifi but we do broad features
testing  IIRC I did IBSS test with b43 it's broken same way is iwlwifi
(look for TSF bug fix)
Thanks
Tomas
