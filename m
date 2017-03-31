Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34441 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbdCaSk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 14:40:29 -0400
Received: by mail-wm0-f42.google.com with SMTP id w204so1146276wmd.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 11:40:28 -0700 (PDT)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221123758.5339-1-johannes@sipsolutions.net>
 <20170221123758.5339-2-johannes@sipsolutions.net>
 <5274c4b4-9bce-208c-e3f2-640d54b81a30@broadcom.com>
 <1490961001.6288.8.camel@sipsolutions.net>
 <91ed1c3e-f28a-b591-344d-e59765a9b944@broadcom.com>
 <1490964139.6288.15.camel@sipsolutions.net>
Cc: Avraham Stern <avraham.stern@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3f38688c-1767-84ac-557e-3d878d15c69f@broadcom.com> (sfid-20170331_204032_682980_6A48120B)
Date: Fri, 31 Mar 2017 20:40:25 +0200
MIME-Version: 1.0
In-Reply-To: <1490964139.6288.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 31-3-2017 14:42, Johannes Berg wrote:
> On Fri, 2017-03-31 at 14:39 +0200, Arend Van Spriel wrote:
>>
>> Ok. Just wondering. I am ok with the proposal with the addition of
>> authorized flag in connect event. So do you expect these to come as
>> non-rfc patches any time soon?
>>
> 
> Hmm. I need to find time to look at it, but I'll be travelling next
> week for netconf/netdev.

ok.

> If you wanted to pick up anything here I won't stop you :)

I am tempted, but it is weekend so I will see how I feel on monday :-p

Regards,
Arend
