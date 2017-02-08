Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35093 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932096AbdBHJ5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:57:36 -0500
Received: by mail-pg0-f49.google.com with SMTP id 194so47791707pgd.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 01:56:56 -0800 (PST)
Subject: Re: [PATCH 1/5] nl80211: fix validation of scheduled scan info for
 wowlan netdetect
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
 <1485518971-28183-2-git-send-email-arend.vanspriel@broadcom.com>
 <1486545047.4603.14.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <338abd1d-dda3-8d6c-0d9a-a5a997f0781e@broadcom.com> (sfid-20170208_105741_303700_38C69844)
Date: Wed, 8 Feb 2017 10:56:49 +0100
MIME-Version: 1.0
In-Reply-To: <1486545047.4603.14.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 8-2-2017 10:10, Johannes Berg wrote:
> On Fri, 2017-01-27 at 12:09 +0000, Arend van Spriel wrote:
>> For wowlan netdetect a separate limit is defined for the number of
>> matchsets. Currently, this limit is ignored and the regular limit
>> for scheduled scan matchsets, ie. struct wiphy::max_match_sets, is
>> used for the net-detect case as well.
> 
> Applied.
> 
> This means that brmcfmac is now broken in mac80211-next for a bit, but
> once it hits net-next and I merge back everything will be fine again,
> so just a few days (and I assume nobody us using brcmfmac from
> mac80211-next anyway ... wireless-testing will be fine)

Well. Almost nobody :-p

Gr. AvS
