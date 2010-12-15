Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:54634 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab0LORMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 12:12:17 -0500
Received: by bwz16 with SMTP id 16so2540236bwz.4
        for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 09:12:16 -0800 (PST)
Message-ID: <4D08F70C.4060302@lwfinger.net>
Date: Wed, 15 Dec 2010 11:12:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/22] rtl8192ce: Initial upload of driver
References: <4D08EA6D.6070106@lwfinger.net> <1292430400.3678.10.camel@jlt3.sipsolutions.net> <20101215163730.GF2377@tuxdriver.com>
In-Reply-To: <20101215163730.GF2377@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2010 10:37 AM, John W. Linville wrote:
> On Wed, Dec 15, 2010 at 05:26:40PM +0100, Johannes Berg wrote:
> 
>>> If you prefer that it go to staging first, I will send it to GregKH, but since
>>> it uses mac80211, I think it is ready for wireless.
>>
>> It looks pretty clean -- so personally, I don't think I'd mind it going
>> in directly.
>>
>> Are you or somebody else planning to make changes to it though? It looks
>> like for example the config semaphore could easily be replaced by a
>> mutex for better debug, for example. Potentially, rate control could be
>> internalised with IEEE80211_HW_HAS_RATE_CONTROL as well, and some
>> similar minor things.

Certainly, the semaphore can be replaced with a mutex. I will need to think
about the rate control.
> 
> Sorry for the delay, Larry!  I've been meaning to post a thorough
> review, but...busy, busy...
> 
> Anyway, I think Johannes is right -- whatever issues remain, it
> would be better to get it in place now than to leave it out or push
> it to staging.
> 
> I intend to mash the series together into a single patch when I merge
> it -- I hope you don't mind.

No, I don't mind. I just put it as multiple patches for review. One nice thing
about being retired is that I don't have to deal with any bean counters who
might worry about number or lines of patches - only making Linux better.

If you want, I can make it a single patch and put it in the git tree I mentioned
for you to pull.

Larry
