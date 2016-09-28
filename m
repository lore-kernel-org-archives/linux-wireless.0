Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56396 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932763AbcI1Pc5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 11:32:57 -0400
Message-ID: <1475076763.4139.42.camel@sipsolutions.net> (sfid-20160928_173301_701785_0463CA67)
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Michael Braun <michael-dev@fami-braun.de>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 28 Sep 2016 17:32:43 +0200
In-Reply-To: <wrfja8esdpcb.fsf@redhat.com>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
         <wrfja8esdpcb.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-09-28 at 11:19 -0400, Jes Sorensen wrote:
> 
> I understand the intentions of this patch are all good, but you need
> to not post patches that include both staging and mainline drivers at
> the same time. In general make it a patchset and do one patch per
> driver.
> 
> Ideally split up changes to generic code into their own patches too.

No Jes, you're wrong this time - this is changing internal API so it
does have to touch all users thereof.

> Last drivers/staging/rtl8723au is gone - so your patch is going to
> fail to apply anyway.

It's there in my tree, for now, so I guess I'll see if it's still there
when I take this in :)

johannes
