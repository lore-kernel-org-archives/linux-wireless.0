Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:51769 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbbHVIjN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2015 04:39:13 -0400
Message-ID: <55D8352E.9040702@msgid.tls.msk.ru> (sfid-20150822_103937_977913_CBD69912)
Date: Sat, 22 Aug 2015 11:39:10 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: linux-only "freshness" auth problem??
References: <55D6F0DB.5050505@msgid.tls.msk.ru>	 (sfid-20150821_114437_353307_BC6FA2E1) <1440152186.2107.14.camel@sipsolutions.net>
In-Reply-To: <1440152186.2107.14.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

21.08.2015 13:16, Johannes Berg wrote:
> On Fri, 2015-08-21 at 12:35 +0300, Michael Tokarev wrote:
>>
>> Aug 21 11:31:49 x200la kernel: wlan0: authenticated
>> Aug 21 11:31:49 x200la kernel: wlan0: waiting for beacon from c0:4a:00:49:1b:f2
>
> Do you see any *kernel* messages after this? I'm half expecting to see
> that the beacon never arrives, or something like that?

The kernel log is repeated.  The next log line is again scanning start,
since NetworkManager (or wpa_supplicant, I'm not familiar with the machinery
involved) request scan again.

> Are the hotels running similar equipment perhaps? If rebooting the AP
> helps then perhaps the APs aren't actually beaconing quite properly -
> maybe you could put the card into sniffer mode (monitor mode) and
> capture what's going on over the air for a bit after this happened?

Can you give some more specific comments please?  We just rebooted the
AP the next time, it all started working again, and I need to install
all the necessary tools while it is working ;)  Since I'm not familiar
with wifi machinery, maybe you can give me specific command lines to
run? :)

Thank you!

/mjt
