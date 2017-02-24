Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42476 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbdBXGnP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 01:43:15 -0500
Message-ID: <1487918592.2540.10.camel@sipsolutions.net> (sfid-20170224_074319_781782_865AEA64)
Subject: Re: [PATCH 162/306] mac80211-hwsim: add length checks before
 allocating skb.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 07:43:12 +0100
In-Reply-To: <1487896109-23851-7-git-send-email-greearb@candelatech.com> (sfid-20170224_012924_608239_582B171A)
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487896109-23851-7-git-send-email-greearb@candelatech.com>
         (sfid-20170224_012924_608239_582B171A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And here's the third patch in a row modifying the same code ...

johannes
