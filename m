Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933234AbcI1PjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 11:39:21 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Braun <michael-dev@fami-braun.de>, kvalo@codeaurora.org,
        akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on AP interfaces
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
        <wrfja8esdpcb.fsf@redhat.com>
        <1475076763.4139.42.camel@sipsolutions.net>
Date: Wed, 28 Sep 2016 11:39:19 -0400
In-Reply-To: <1475076763.4139.42.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 28 Sep 2016 17:32:43 +0200")
Message-ID: <wrfj1t04c9ug.fsf@redhat.com> (sfid-20160928_173954_021875_FA61E0CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Wed, 2016-09-28 at 11:19 -0400, Jes Sorensen wrote:
>> 
>> I understand the intentions of this patch are all good, but you need
>> to not post patches that include both staging and mainline drivers at
>> the same time. In general make it a patchset and do one patch per
>> driver.
>> 
>> Ideally split up changes to generic code into their own patches too.
>
> No Jes, you're wrong this time - this is changing internal API so it
> does have to touch all users thereof.

Even in this case, change the individual components in individual
patches and post them as a set.

>> Last drivers/staging/rtl8723au is gone - so your patch is going to
>> fail to apply anyway.
>
> It's there in my tree, for now, so I guess I'll see if it's still there
> when I take this in :)

Changes to staging needs to go in via staging, and rtl8723au is gone
from the staging tree.

Cheers,
Jes
