Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760213AbbKTQh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 11:37:56 -0500
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide unnecessary
 code
To: Johannes Berg <johannes@sipsolutions.net>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
 <564F3B36.4040101@suse.com> <1448033373.3141.46.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Michal Marek <mmarek@suse.com>
Message-ID: <564F4C62.2070006@suse.com> (sfid-20151120_173759_008174_11508D66)
Date: Fri, 20 Nov 2015 17:37:54 +0100
MIME-Version: 1.0
In-Reply-To: <1448033373.3141.46.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-11-20 16:29, Johannes Berg wrote:
> On Fri, 2015-11-20 at 16:24 +0100, Michal Marek wrote:
>> On 2015-11-12 23:00, Johannes Berg wrote:
>>> +	count MAC80211_NUM_DRIVERS
>>> +	select MAC80211_DRIVER_NO_HWFLAGS
>>
>> Hi Johannes,
>>
>> The MAC80211_DRIVER_NO_HWFLAGS config does not seem to be used
>> anywhere in the logic.
>>
> 
> Yeah, I forgot in this version. I have an updated one at
> 
> https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/lo
> g/?h=hwflags-elide


OK.

> haven't sent it yet though because I'm not really sure it's worth it at
> all?

I did not have time to look at your series until today.

Michal
