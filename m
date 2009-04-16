Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42835 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZDPLLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:11:44 -0400
Received: by bwz17 with SMTP id 17so337341bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 04:11:42 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] mac80211 powersave improvements
References: <20090415171046.336006351@sipsolutions.net>
	<87iql4981b.fsf@litku.valot.fi>
	<1239880000.9737.20.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 14:11:40 +0300
In-Reply-To: <1239880000.9737.20.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 13\:06\:40 +0200")
Message-ID: <87eivs97kj.fsf@litku.valot.fi> (sfid-20090416_131148_927766_A2832086)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-16 at 14:01 +0300, Kalle Valo wrote:
>
>> I think this a bad idea. For normal users we should not enable powersave
>> by default, at least not yet. I believe that there would be so much
>> problems that we would have to revert the change eventually.
>
> We can go with the configurable one -- and default y in wireless-testing
> but default n in mainline for a while. Get press coverage etc. and at
> some point flip the switch.

That's a lot better. Gradually expanding the amount of users makes it
easier. Big bang is always difficult and usually doomed to a failure :)

>> > Should we have a default setting for the dynamic PS
>> > timeout?
>> 
>> Yes. Having timeout zero makes no sense in normal laptop use.
>
> So, what's a good default? Fairly long I'd say, maybe 500ms?

Yes, at least. Maybe even 1s? We can gradually start lowering it.

-- 
Kalle Valo
