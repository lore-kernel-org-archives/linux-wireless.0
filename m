Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.172]:22024 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbXH2OdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 10:33:00 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
	<87lkccf30m.fsf@tikku.osso.net>
	<1187270479.5141.44.camel@johannes.berg> <87643f4kkh.fsf@nokia.com>
	<1187275344.23489.6.camel@johannes.berg> <871wdphsus.fsf@nokia.com>
	<1188290911.7837.65.camel@johannes.berg> <87absbsz5f.fsf@nokia.com>
	<1188299159.7837.96.camel@johannes.berg> <87sl63prsg.fsf@nokia.com>
	<1188317935.7837.106.camel@johannes.berg> <878x7v8rcm.fsf@nokia.com>
	<1188326593.7837.118.camel@johannes.berg> <87fy2355yy.fsf@nokia.com>
	<1188376637.7837.149.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Wed, 29 Aug 2007 17:35:06 +0300
In-Reply-To: <1188376637.7837.149.camel@johannes.berg> (ext Johannes Berg's message of "Wed\, 29 Aug 2007 10\:37\:17 +0200")
Message-ID: <873ay2v279.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2007-08-29 at 07:18 +0300, Kalle Valo wrote:
>
>> > Can you disable QoS and see if the same weird frames show up again? b43
>> > doesn't really support QoS yet but I don't think that should be causing
>> > such frame corruption.
>> 
>> From b43 or N800? 
>
> N800, I guess, if possible. But since you didn't do this yet you might
> want to try the stuff I sent you first.

I tested your multicast stuff and it worked. Do you still want me to
test with QoS disabled in N800?

>> > Interestingly, your N800 seems to pick up the frames correctly since it
>> > did reply to the ping packets... 
>> 
>> Yes, N800 managed to receive some ping packets from the laptop
>
> Yes, the odd thing however is that it replies to these mangled packets.
> I would guess that's a bug in the QoS implementation on the N800.

Good point. I'll look into that.

-- 
Kalle Valo
