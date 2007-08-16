Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.172]:55259 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbXHPOcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 10:32:41 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
	<87lkccf30m.fsf@tikku.osso.net>
	<1187270479.5141.44.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Thu, 16 Aug 2007 17:31:58 +0300
In-Reply-To: <1187270479.5141.44.camel@johannes.berg> (ext Johannes Berg's message of "Thu\, 16 Aug 2007 15\:21\:19 +0200")
Message-ID: <87643f4kkh.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Johannes Berg" <johannes@sipsolutions.net> writes:

> On Thu, 2007-08-16 at 08:43 +0300, Kalle Valo wrote:
>
>>  Few devices do that, so I
>> wonder if mac80211 supports that properly?
>
> It should, as far as I can tell, but I haven't been able to quite
> pinpoint it yet. I'll need to get a third device fully monitoring.

What driver are you using in? I tried b43 from wireless-dev this
morning and couldn't get my N800 to see it. I guess it wasn't sending
beacons, but I didn't have time to check that. I'll try again tonight.

Are there any tricks or should this be enough with b43:

iwconfig wlan0 mode master channel 2 essid mac80211
ip link set wlan0 up

-- 
Kalle Valo
