Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:60702 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYKOCFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 21:05:38 -0500
Received: by yw-out-2324.google.com with SMTP id 9so743108ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 18:05:37 -0800 (PST)
Message-ID: <43e72e890811141805w7e3b1c05neeac9fe0987e0e41@mail.gmail.com> (sfid-20081115_030542_884394_0785389E)
Date: Fri, 14 Nov 2008 18:05:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: make Minstrel the default rate control algorithm
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, derek@indranet.co.nz
In-Reply-To: <1226713901.4120.44.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226713493-4449-1-git-send-email-lrodriguez@atheros.com>
	 <1226713901.4120.44.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 5:51 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>>
>>  config MAC80211_RC_PID
>>       bool "PID controller based rate control algorithm" if EMBEDDED
>> -     default y
>
> don't we want to remove that if embedded there then? otoh, who really
> cares...

Better in a seperate patch then ?

>>  config MAC80211_RC_DEFAULT
>>       string
>> -     default "pid" if MAC80211_RC_DEFAULT_PID
>>       default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
>> +     default "pid" if MAC80211_RC_DEFAULT_PID
>>       default ""
>
> I don't think that matters :)

Oh ok. Either way. ACK/NACK?

  Luis
