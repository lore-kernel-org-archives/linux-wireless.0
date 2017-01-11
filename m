Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33324 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764713AbdAKPI7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:08:59 -0500
Message-ID: <1484147337.29931.15.camel@sipsolutions.net> (sfid-20170111_161106_248525_77DDE0A3)
Subject: Re: mac80211: Fix headroom allocation when forwarding mesh pkt
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 11 Jan 2017 16:08:57 +0100
In-Reply-To: <e3b7a95724944c6aadc8512eadfe1c1d@ceva-dsp.com> (sfid-20170111_155422_675776_897E23BB)
References: <e3b7a95724944c6aadc8512eadfe1c1d@ceva-dsp.com>
         (sfid-20170111_155422_675776_897E23BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 14:39 +0000, Cedric Izoard wrote:
> This patch fix issue introduced by commit
> "mac80211: Ensure enough headroom when forwarding mesh pkt"

I reworded that, and replaced the commit reference with a Fixes: tag,
please try to do that in the future.

Applied, but I also reindented that to match the expression.

johannes
