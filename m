Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35997 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754941AbdCGJ5h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 04:57:37 -0500
Received: by mail-qk0-f178.google.com with SMTP id 1so198557966qkl.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 01:57:12 -0800 (PST)
Subject: Re: [PATCH] mac80211: ignore VHT membership selector when parsing
 rates
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170306220113.4666-1-johannes@sipsolutions.net>
 <220e1799-9fba-c113-805d-3589421cdecd@broadcom.com>
 <1488876157.2366.0.camel@sipsolutions.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <188f17a6-4814-9c3c-003b-685e9cbdcbca@broadcom.com> (sfid-20170307_110019_205922_02812E8F)
Date: Tue, 7 Mar 2017 10:49:05 +0100
MIME-Version: 1.0
In-Reply-To: <1488876157.2366.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 7-3-2017 9:42, Johannes Berg wrote:
> 
>>>  
>>>  		/*
>>> -		 * BSS_MEMBERSHIP_SELECTOR_HT_PHY is defined in
>>> 802.11n-2009
>>> -		 * 7.3.2.2 as a magic value instead of a rate.
>>> Hence, skip it.
>>> +		 * Skip HT and VHT BSS membership selectors since
>>> they're not
>>> +		 * rates.
>>>  		 *
>>>  		 * Note: Even through the membership selector and
>>> the basic
>>
>> typo: through -> though.
> 
> That's just existing context ;-)
> 
> Will fix here.

I noticed and indeed could create a patch for it, but this is easier
(for me :-p ).

Gr. AvS
