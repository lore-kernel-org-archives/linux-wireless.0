Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35703 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbcLEPFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 10:05:49 -0500
Received: by mail-oi0-f49.google.com with SMTP id b126so341670132oia.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 07:05:49 -0800 (PST)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
 <1480949899.31788.34.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <5845824B.4090304@gmail.com> (sfid-20161205_160553_166824_4BCA7EF6)
Date: Mon, 5 Dec 2016 09:05:47 -0600
MIME-Version: 1.0
In-Reply-To: <1480949899.31788.34.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 12/05/2016 08:58 AM, Johannes Berg wrote:
>
>> Detecting it is easy, sure.  But I'm a bit lost on how you propose
>> to
>> 'use' it.  The connection is active up until the next rekey
>> event.  If
>> rekey offloading is supported, then this might never involve user
>> space.
>>    But if it isn't (and I can't get rekey offload to work on any
>> recent
>> kernel I tried) then how do you propose userspace obtains the rekey
>> counter, or the various keys used in the connection?
>>
>> What about all the other state information?  FT, Pre-Authentication,
>> etc?
>
> Well, no, that'd only work with an open connection :)
>

And even that is questionable in my mind for some of the more advanced 
cases.

But I'm not sure what your point is, do you still have objections to 
this approach?

Regards,
-Denis
