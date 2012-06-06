Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51589 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2FFHA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 03:00:58 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] new wireless stack trees
References: <1338898271.4514.38.camel@jlt3.sipsolutions.net>
Date: Wed, 06 Jun 2012 10:00:56 +0300
In-Reply-To: <1338898271.4514.38.camel@jlt3.sipsolutions.net> (Johannes Berg's
	message of "Tue, 05 Jun 2012 14:11:11 +0200")
Message-ID: <87sje86i1j.fsf@purkki.adurom.net> (sfid-20120606_090102_390880_93EDA306)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Given the amount of work going on in the various wireless stack
> components, I've decided that I'll reflect my maintainer role also in
> git trees. I've created new trees and will pick patches for
>  * mac80211
>  * cfg80211
>  * rfkill (if needed)
>
> into the new trees
>  * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211.git;a=summary
>  * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=summary

Great!

> I won't maintain an integration tree like John's wireless-testing,
> please continue to use his. If merge conflicts make it necessary, I'll
> resolve them in separate branches etc. and work it out with John.

So when working on mac80211 or cfg80211 changes you still recommend the
developer to use wireless-testing, did I understand this correctly?

-- 
Kalle Valo
