Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46738 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZK0Lcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 06:32:55 -0500
Received: by bwz27 with SMTP id 27so1101056bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 03:33:00 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 06/12] wl1251: fix payload alignment
References: <20091126150141.917.35278.stgit@tikku>
	<20091126150904.917.8182.stgit@tikku> <877htd9v5a.fsf@purkki.valot.fi>
	<1259259183.24540.0.camel@johannes.local>
	<873a409qdg.fsf@purkki.valot.fi>
	<1259320319.5428.17.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Nov 2009 13:32:57 +0200
In-Reply-To: <1259320319.5428.17.camel@johannes.local> (Johannes Berg's message of "Fri\, 27 Nov 2009 12\:11\:59 +0100")
Message-ID: <87tywg8aom.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-11-27 at 13:08 +0200, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > Eh, turn off the debugging option ...
>> 
>> Sure. But isn't this warning going to create false alarms for others?
>
> That's why it says "Say N unless you're writing a mac80211 based
> driver."

I was "writing a mac80211 based driver" so I enabled it, and it
tricked me =)

> Maybe it should say "Say N unless you want to debug potential
> alignment issues with your driver." Or maybe it should just go away
> now that we align things properly in mac80211, and most firmware
> either handles it or not, and there's nothing we can do about the
> firmware most of the time... And mesh makes it more complex anyway
> than the warning checks.

Maybe we should just remove it. Like you just said, there isn't much
we can do. I'll come up with a patch unless I get objections.

-- 
Kalle Valo
