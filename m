Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:32813 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdFILVV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 07:21:21 -0400
Received: by mail-wr0-f175.google.com with SMTP id v104so29489133wrb.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 04:21:20 -0700 (PDT)
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
 <29d43b7d-6cb6-0734-6a52-31fa98e9c1bc@broadcom.com>
 <1496050303.2467.3.camel@sipsolutions.net>
 <d41f58e9-b12e-9e52-a0fb-b674d278353b@broadcom.com>
 <1496999284.2424.7.camel@sipsolutions.net>
 <92d6d845-acd1-078a-9121-ba6eb22fd6fd@broadcom.com>
 <1497005964.2424.10.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b038f45e-a270-fb0c-5608-903e60b9b4a4@broadcom.com> (sfid-20170609_132124_172115_A93EC205)
Date: Fri, 9 Jun 2017 13:21:17 +0200
MIME-Version: 1.0
In-Reply-To: <1497005964.2424.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/9/2017 12:59 PM, Johannes Berg wrote:
> On Fri, 2017-06-09 at 12:34 +0200, Arend van Spriel wrote:
> 
>> Not trying to change your opinion ;-). Just getting it all clear. As
>> a matter of fact I already have my wpa_s use the offload without any
>> debug/config option. As brcmfmac can use override to disable
>> firmware features I also do not need such in wpa_s.
> 
> Sounds good to me :)
> 
> So I guess we're aligned on this - do you need to respin as a result of
> this discussion, or should I review the patches again?

I will respin. Actually only change will be the extra documentation 
section in which I need to incorporate your feedback.

Regards,
Arend
