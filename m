Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53710 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdC2RLl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 13:11:41 -0400
Subject: Re: [PATCH v3 1/4] mac80211-hwsim: notify user-space about channel
 change.
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
 <1490776922.7948.9.camel@sipsolutions.net>
 <260bf7e1-5ff2-709a-419b-df54b80c87f0@candelatech.com>
 <1490806271.7948.22.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <6ddd5a26-042b-0eaf-e8f2-11833ede300b@candelatech.com> (sfid-20170329_191145_502332_C09594F9)
Date: Wed, 29 Mar 2017 10:11:40 -0700
MIME-Version: 1.0
In-Reply-To: <1490806271.7948.22.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2017 09:51 AM, Johannes Berg wrote:
>
>> The patch appeared to solve my problem, and it seems an improvement
>> over what is there currently.  Whoever wants it to support even more
>> things can add that in the future?
>
> Yes, that's kinda true. However, it also means that wmediumd (or
> similar) would have to support the two APIs. It'd be simpler for them
> to just have to support a single one, no?

I really don't understand what change you are suggesting.  Anything that
uses a new API needs to change, and as API is further improved, then the
app will need to change again.  Netlink's saving grace is that it is easy to
add new data members and so support new API in a forward/backward compatible manner.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
