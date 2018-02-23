Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55646 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbeBWL3n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 06:29:43 -0500
Message-ID: <1519385379.2231.10.camel@sipsolutions.net> (sfid-20180223_122947_383387_256D20AD)
Subject: Re: pull-request: mac80211-next 2018-02-22
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Fri, 23 Feb 2018 12:29:39 +0100
In-Reply-To: <20180222.151902.347947675667607885.davem@davemloft.net>
References: <20180222201619.30037-1-johannes@sipsolutions.net>
         <20180222.151902.347947675667607885.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-02-22 at 15:19 -0500, David Miller wrote:
> 
> Pulled, thank you!

Thanks. I just realized that I have a patch pending for -next that
depends another commit in net/mac80211 (or would otherwise conflict
badly while applying, and again while merging later), could I ask you
to pull net into net-next at some point now?

Thanks,
johannes
