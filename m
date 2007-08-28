Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.173]:30550 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbXH1LBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 07:01:22 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
	<87lkccf30m.fsf@tikku.osso.net>
	<1187270479.5141.44.camel@johannes.berg> <87643f4kkh.fsf@nokia.com>
	<1187275344.23489.6.camel@johannes.berg> <871wdphsus.fsf@nokia.com>
	<1188290911.7837.65.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Tue, 28 Aug 2007 13:59:24 +0300
In-Reply-To: <1188290911.7837.65.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 28 Aug 2007 10\:48\:31 +0200")
Message-ID: <87absbsz5f.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Heh, I guess I have used madwifi too much :) 
>
> Heh, yeah, the BSD folks insist of putting all that functionality into
> the kernel because for some reason they believe it'll magically make it
> more stable (they told me that, minus the "magically")

Hostapd makes sense to me (now) and it was really easy to setup, so no
problems with that. 

I just have a fear that we don't endup in "udev-hell", that is
incompatibility between kernel and hostapd versions. It was just awful
with udev few years ago, let's try to avoid that. Official hostapd
releases should work with all official kernel releases, without any
exceptions.

> In any case, I'm fairly sure the TIM is just wrong, if you have a third
> device you could try capturing the beacons and check that the TIM is
> never updated.

I will check that later and send the results here.

-- 
Kalle Valo
