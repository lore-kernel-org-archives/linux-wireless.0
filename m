Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47072 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbeAVPbZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 10:31:25 -0500
Message-ID: <1516635078.2508.38.camel@sipsolutions.net> (sfid-20180122_163132_982467_B025EEC0)
Subject: Re: pull-request: mac80211-next 2018-01-22
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 22 Jan 2018 16:31:18 +0100
In-Reply-To: <20180122.101728.704853095626932714.davem@davemloft.net>
References: <20180122131501.21953-1-johannes@sipsolutions.net>
         <20180122.101728.704853095626932714.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-22 at 10:17 -0500, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Mon, 22 Jan 2018 14:15:00 +0100
> 
> > A few more (only four, really) changes have come in, so I figured
> > since the merge window hasn't opened yesterday, I'd still send them
> > to you.
> > 
> > Please pull and let me know if there's any problem.
> 
> I had to resolve a conflict in mac80211_hwsim.c, please check my
> resolution and send me any fixes which are necessary.

Sorry, my bad, I apologize. I knew about this and didn't think of it
when writing the pull request.

Resolution looks good - I was worried about the destruction order for a
second there, but it doesn't actually matter.

Thanks!

johannes
