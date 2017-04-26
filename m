Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44998 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1949823AbdDZItp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:49:45 -0400
Message-ID: <1493196583.2464.14.camel@sipsolutions.net> (sfid-20170426_104950_718412_080D2D7F)
Subject: Re: [PATCH V3 1/9] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 26 Apr 2017 10:49:43 +0200
In-Reply-To: <3ce6aed5-7d00-3446-a39b-b5da4b788358@broadcom.com> (sfid-20170426_104646_540794_A2B6AFE6)
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
         <1492776308-15120-2-git-send-email-arend.vanspriel@broadcom.com>
         <1493149747.15192.0.camel@sipsolutions.net>
         <3ce6aed5-7d00-3446-a39b-b5da4b788358@broadcom.com>
         (sfid-20170426_104646_540794_A2B6AFE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FWIW:

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=978812b3f43dda86e20588cfe0a4a244c4fab141


On Wed, 2017-04-26 at 10:46 +0200, Arend van Spriel wrote:

> Sure. In the worker we are already iterating so I guess we could.
> The number of internal fields in struct cfg80211_sched_scan_request
> with one of them being the list_head. Thinking about hiding those
> from the drivers. Is it worth it?

I guess it could be done, but I'm tending towards doing that less
again, I have no strong preference in this case. If it was something
that seems likely to get abused, perhaps, but here...

johannes
