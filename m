Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34956 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbeF3UpU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 16:45:20 -0400
Message-ID: <1530391517.7210.1.camel@sipsolutions.net> (sfid-20180630_224531_626923_17DF05CB)
Subject: Re: pull-request: mac80211-next 2018-06-29
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Sat, 30 Jun 2018 22:45:17 +0200
In-Reply-To: <20180630.211728.888180353537471428.davem@davemloft.net>
References: <20180629115906.2045-1-johannes@sipsolutions.net>
         <20180630.211728.888180353537471428.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-06-30 at 21:17 +0900, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Fri, 29 Jun 2018 13:59:05 +0200
> 
> > Here's the next round of -next updates. This includes the promised
> > HE stuff but it's not all that big in the end, most of it is just
> > additions to the protocol header file :-)
> 
> :-)
> 
> > Please pull and let me know if there's any problem.
> 
> There was a small merge conflict in net/mac80211/scan.c, I arranged
> it such that the kcalloc() conversion was preserved.

Huh, sorry, hadn't seen that massive patch, I see it now.

> Please send me any necessary fixups if I didn't do it properly.

No need, looks fine. I diffed it to my tree and the only change is the
kcalloc conversion, as expected.

Thanks!

johannes
