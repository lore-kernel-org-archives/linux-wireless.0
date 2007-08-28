Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.173]:24534 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbXH1SJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 14:09:20 -0400
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
	<1188317935.7837.106.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Tue, 28 Aug 2007 21:08:09 +0300
In-Reply-To: <1188317935.7837.106.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 28 Aug 2007 18\:18\:55 +0200")
Message-ID: <878x7v8rcm.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> But that's not all, also multicast frames (including ARP broadcast)
>> are not buffered correctly. They are sent randomly instead of directly
>> after a DTIM beacon. Also Multicast bit is not set and DTIM is always
>> zero even though DTIM period is two.
>
> Hm, yeah, I almost expected this, b43 hardware has some capabilities for
> this but we don't really know how to use it yet. We also need to upload
> the DTIM count to the hardware (shm somewhere) 

I hope you have time to investigate this, because I really would like
to have Nokia N800 and 770 working with b43 AP. So if you need more
testing, just ask.

>> I also some really odd frames sent by b43 when N800 had PSM enabled.
>> Never seen it before, no idea what it is. Dump at the of this message.
>
> Could you send me a packet capture in pkt format via private mail?

Sent.

-- 
Kalle Valo
