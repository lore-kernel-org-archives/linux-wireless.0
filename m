Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.173]:31954 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXH1LMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 07:12:34 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
	<87lkccf30m.fsf@tikku.osso.net>
	<1187270479.5141.44.camel@johannes.berg> <87643f4kkh.fsf@nokia.com>
	<1187275344.23489.6.camel@johannes.berg> <871wdphsus.fsf@nokia.com>
	<1188290911.7837.65.camel@johannes.berg> <87absbsz5f.fsf@nokia.com>
	<1188299159.7837.96.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Tue, 28 Aug 2007 14:11:36 +0300
In-Reply-To: <1188299159.7837.96.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 28 Aug 2007 13\:05\:59 +0200")
Message-ID: <87642zsyl3.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2007-08-28 at 13:59 +0300, Kalle Valo wrote:
>
>> I just have a fear that we don't endup in "udev-hell", that is
>> incompatibility between kernel and hostapd versions. It was just awful
>> with udev few years ago, let's try to avoid that. Official hostapd
>> releases should work with all official kernel releases, without any
>> exceptions.
>
> Well, with mac80211 mainline kernels currently don't support AP mode at
> all, and wireless-dev/hostapd are quite in lockstep. 

Yeah, I understood that.

> As soon as we merge the AP mode stuff into mainline, however, it
> will be via nl80211 which shall be a stable interface for that.

That's a relief for me :) Thanks.

-- 
Kalle Valo
