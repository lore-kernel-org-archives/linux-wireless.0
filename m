Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49926 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752756AbdCPXKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 19:10:16 -0400
Message-ID: <1489704244.3930.7.camel@sipsolutions.net> (sfid-20170317_001019_106642_EBFC8F1A)
Subject: Re: netdev level filtering? perhaps pushing socket filters down?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 16 Mar 2017 23:44:04 +0100
In-Reply-To: <58CB1714.8000305@candelatech.com>
References: <1489703635.3930.5.camel@sipsolutions.net>
         <58CB1714.8000305@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Attach at just above the driver, before it ever gets to
> stations/vdevs, and ignore radiotap headers and/or add special
> processing for metadata like rx-info?

That'd be a different feature, perhaps more like XDP.

There anyway is no radiotap header at that point, but not changing
whether or not it makes it to other virtual interfaces is actually not
what we're looking for here at all.

johannes
