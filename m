Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34765 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdE2JSf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 May 2017 05:18:35 -0400
Received: by mail-qk0-f182.google.com with SMTP id d14so3949389qkb.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 May 2017 02:18:34 -0700 (PDT)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
 <1495030794.2442.21.camel@sipsolutions.net>
 <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
 <1495099355.2553.1.camel@sipsolutions.net>
 <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
 <1495104012.2553.3.camel@sipsolutions.net>
 <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
 <1495189263.3274.4.camel@sipsolutions.net>
 <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com>
 <1495448886.2653.12.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <29d43b7d-6cb6-0734-6a52-31fa98e9c1bc@broadcom.com> (sfid-20170529_111851_593793_C5E3A239)
Date: Mon, 29 May 2017 11:18:22 +0200
MIME-Version: 1.0
In-Reply-To: <1495448886.2653.12.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 5/22/2017 12:28 PM, Johannes Berg wrote:
> On Mon, 2017-05-22 at 12:14 +0200, Arend van Spriel wrote:
>>
>> There is a (small) chance of regression with older devices as stated
>> above and I would like to keep the fallback option for that. Also
>> people  may like to have a choice. I am not so sure about whether
>> NEW_KEY support is enough or a new ext_feature flag is needed. I am
>> inclined to say the NEW_KEY support is sufficient.
> 
> Ok, your call.
> 
> Note that this (checking NEW_KEY) only works when you don't have any
> split between AP/client cases. Not sure what's the case for you.

Late response so hopefully you recall, but what do you mean by "any 
split between AP/client cases"?

Regards,
Arend
