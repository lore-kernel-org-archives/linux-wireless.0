Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48690 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1FTT4A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 15:56:00 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/27] mac80211: create mac80211_ prefix
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
	<1f42877e8c429b956640a6e9d97127fc@secure.sipsolutions.net>
	<87mxhg1zmb.fsf@purkki.adurom.net>
	<20110620192418.GB2251@tuxdriver.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 20 Jun 2011 22:55:58 +0300
In-Reply-To: <20110620192418.GB2251@tuxdriver.com> (John W. Linville's message of "Mon\, 20 Jun 2011 15\:24\:18 -0400")
Message-ID: <8762o01dm9.fsf@purkki.adurom.net> (sfid-20110620_215604_410214_9D10395A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Fri, Jun 17, 2011 at 02:11:40PM +0300, Kalle Valo wrote:
>
>> What do you suggest here? So that we should rename everything (both
>> mac80211 and 19 drivers) in one go? If we do that, we would have to do
>> everything in one patch to not break bisect, and it would be huge.
>> 
>> With mac80211-compat.h it's possible to break down the patches into
>> small pieces. This makes it easier to create the patches and, most
>> importantly, review them.
>> 
>> I'm willing to work on that huge patch if we so decide, but I'm not
>> sure if that's the correct way.
>> 
>> Ah, while writing this I realised that I could instead rename symbols
>> in mac80211.h one at a time and that way the patches would be smaller.
>> Did you mean that?
>
> Is there going to be another spin of this?

Yes, based on Johannes' feedback I'll drop this patchset and will
rework it. Instead I will send patches which rename mac80211.h symbols
one at a time (both from mac80211 and drivers at the same). Again this
won't happen all in once, instead I will send few patchsets to make it
easier for me. But this way we get to avoid the ugly mac80211-compat.h
file.

> I had trouble applying patch 5 -- maybe this is something that is
> best handled with a pull request?

Sure, if it's easier for you I can do that.

-- 
Kalle Valo
