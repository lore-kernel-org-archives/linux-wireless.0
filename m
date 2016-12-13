Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f181.google.com ([209.85.210.181]:34710 "EHLO
        mail-wj0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbcLMUJa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 15:09:30 -0500
Received: by mail-wj0-f181.google.com with SMTP id tg4so112663186wjb.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2016 12:09:29 -0800 (PST)
Subject: Re: [RFC V3 03/11] nl80211: add support for gscan
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
 <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
 <1481645962.20412.41.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3dd64ef5-f05e-4a80-0c98-9a2548affd1c@broadcom.com> (sfid-20161213_211201_391700_AB82A925)
Date: Tue, 13 Dec 2016 21:09:25 +0100
MIME-Version: 1.0
In-Reply-To: <1481645962.20412.41.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 13-12-2016 17:19, Johannes Berg wrote:
> On Mon, 2016-12-12 at 11:59 +0000, Arend van Spriel wrote:
>> This patch adds support for GScan which is a scan offload feature
>> used in Android.
> 
> Found a few places with spaces instead of tabs as indentation, and
> spurious braces around single-statement things, but other than that it
> looks fine from a patch/nl80211 POV.

I added a check in wiphy_register() in this patch which actually is more
appropriate with the "gscan capabilities" patch.

> Haven't really looked into the details of gscan itself now though,
> sorry.
> 
> There's a bit of a weird hard-coded restriction to 16 channels too,
> that's due to the bucket map?

Uhm. Is there? I will check, but if you can give me a pointer where to
look it is appreciated.

Regards,
Arend
