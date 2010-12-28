Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0L1Ivf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:51:35 -0500
Subject: Re: Patches submitted should apply to which git repository?
From: Johannes Berg <johannes@sipsolutions.net>
To: Naveenan <initramd@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=MhYzv54WvEwYGh15KC4LHyM=EVd-s+1BG8pBT@mail.gmail.com>
References: <AANLkTi=MhYzv54WvEwYGh15KC4LHyM=EVd-s+1BG8pBT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 09:51:33 +0100
Message-ID: <1293526293.3526.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 02:40 -0600, Naveenan wrote:
> Hi,
> I would like to submit a patch to linux-wireless and was wondering
> what git repository should my patch be apply-able to so that there
> wouldn't be any merge conflicts?
> 
> I went through:
> http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
> but couldn't find this information there so was hoping someone could
> point the exact git repository. My current patch applies to
> wireless-testing but doesn't apply to wireless-2.6 (due to a trivial
> merge conflict) . The changes I'm making are to mac80211.

If they're fixes and required in wireless-2.6, then you should make them
apply there, but ask yourself if they really need to be there. If not,
you can typically just submit them on top of wireless-testing, although
they will have to be applied to wireless-next-2.6.

johannes

