Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43666 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754944AbdIGJkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 05:40:45 -0400
Message-ID: <1504777242.6177.2.camel@sipsolutions.net> (sfid-20170907_114207_566754_37D45C1A)
Subject: Re: using vulnerability ids in patches
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 07 Sep 2017 11:40:42 +0200
In-Reply-To: <7b09c3d4-a18a-6bc3-6445-8911c088258f@broadcom.com> (sfid-20170907_113805_461947_FBD398F8)
References: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com>
         <1504774743.6177.0.camel@sipsolutions.net>
         <7b09c3d4-a18a-6bc3-6445-8911c088258f@broadcom.com>
         (sfid-20170907_113805_461947_FBD398F8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-07 at 11:38 +0200, Arend van Spriel wrote:
> 
> Ok. So doing this I see a number of instances where the CVE-ID is 
> mentioned in the commit message, but there are also instances that
> use  the 'Fixes:' tag. Does it make sense to use that or does it
> serve another purpose?

Huh, I don't think that makes sense - the Fixes: tag should be for the
commit that introduced the bug. I guess parsers will have to ignore
garbage so it's probably safe, but I don't think you could mine for CVE
fixes that way anyway ...

johannes
