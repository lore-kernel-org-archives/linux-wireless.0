Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34639 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdDLOIZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 10:08:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id x75so6650036wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 07:08:25 -0700 (PDT)
Date: Wed, 12 Apr 2017 16:08:23 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next v5 4/5] netlink: pass extended ACK struct to
 parsing functions
Message-ID: <20170412140823.GJ1952@nanopsycho> (sfid-20170412_160842_581299_ACC017FB)
References: <20170412123408.22012-1-johannes@sipsolutions.net>
 <20170412123408.22012-5-johannes@sipsolutions.net>
 <20170412131708.GC1952@nanopsycho>
 <8737ddd8r0.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8737ddd8r0.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Apr 12, 2017 at 04:02:27PM CEST, kvalo@codeaurora.org wrote:
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> Wed, Apr 12, 2017 at 02:34:07PM CEST, johannes@sipsolutions.net wrote:
>>>From: Johannes Berg <johannes.berg@intel.com>
>>>
>>>Pass the new extended ACK reporting struct to all of the
>>
>> Johannes, I wonder, is there a reason you ignore my comments about
>> narrow descriptions? Why don't you use the whole line?
>
>Seriously, you ask that with totally unnecessary 3800 lines of quotes?
>
>(Or at least I assume so, I didn't bother to check if you had any
>comments there as it would have taken forever to find them.)

Yep, that I did not remove. Sorry about that. Will behave the next time.
