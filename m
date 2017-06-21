Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0086.outbound.protection.outlook.com ([104.47.40.86]:5536
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751069AbdFUHic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 03:38:32 -0400
Subject: Re: [RFC] mac80211: support non-data TXQs
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20170620210309.1193-1-johannes@sipsolutions.net>
 <c8637109-0292-23af-8bc6-8a7ba8e19595@quantenna.com>
 <1498028959.4955.1.camel@sipsolutions.net>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <b4a28e42-bc8c-57ff-0bc0-e0b1eed6a6c1@quantenna.com> (sfid-20170621_093837_558074_5BDFC7AA)
Date: Wed, 21 Jun 2017 00:38:16 -0700
MIME-Version: 1.0
In-Reply-To: <1498028959.4955.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2017 12:09 AM, Johannes Berg wrote:
> 
>> [snip]
> [please trim the amount of text you quote]
> 
>>> -           txqi->txq.ac = ieee80211_ac_from_tid(tid);
>>> +           if (tid == IEEE80211_NUM_TIDS + 1)
>>> +                   txqi->txq.ac = IEEE80211_AC_VO;
>>
>> Why voice, maybe commit message should mention it?
> 
> That's standard for management frames, I really didn't think that'd
> need any comment?

You're right, for some reason I thought about "null data" frames instead 
of "no data" frames.

> 
> johannes
> 
