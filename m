Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:34717 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdCaMjs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 08:39:48 -0400
Received: by mail-wr0-f179.google.com with SMTP id l43so105988200wre.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 05:39:47 -0700 (PDT)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221123758.5339-1-johannes@sipsolutions.net>
 <20170221123758.5339-2-johannes@sipsolutions.net>
 <5274c4b4-9bce-208c-e3f2-640d54b81a30@broadcom.com>
 <1490961001.6288.8.camel@sipsolutions.net>
Cc: Avraham Stern <avraham.stern@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <91ed1c3e-f28a-b591-344d-e59765a9b944@broadcom.com> (sfid-20170331_143951_663492_CB38BAC0)
Date: Fri, 31 Mar 2017 14:39:44 +0200
MIME-Version: 1.0
In-Reply-To: <1490961001.6288.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 31-3-2017 13:50, Johannes Berg wrote:
> On Tue, 2017-03-28 at 12:50 +0200, Arend Van Spriel wrote:
>>
>> So looking at wpa_supplicant RFC patches I see that it now diverts
>> driver_nl80211_set_key() for ALG_PMK case to the new api. So why not
>> extending CMD_NEW_KEY to support ALG_PMK?
> 
> I don't really care what the supplicant does, but IMHO having
> completely different types of keys in the same API isn't a good idea.
> We'd have to invent (a) cipher suite(s), or new attributes, to even
> encapsulate that in netlink - and the usage is completely different
> etc.

Ok. Just wondering. I am ok with the proposal with the addition of
authorized flag in connect event. So do you expect these to come as
non-rfc patches any time soon?

Regards,
Arend
