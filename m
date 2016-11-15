Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46980 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941393AbcKOJbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 04:31:32 -0500
Message-ID: <1479202288.12007.25.camel@sipsolutions.net> (sfid-20161115_103145_088880_1D339265)
Subject: Re: [PATCH 1/2] cfg80211: Add support to set tx power for a station
 associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Ben Greear <greearb@candelatech.com>
Cc: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Tue, 15 Nov 2016 10:31:28 +0100
In-Reply-To: <8908f6e7bb8ca043fbeb07ee8b004e8f@codeaurora.org>
References: <1465926256-6463-1-git-send-email-arnagara@qti.qualcomm.com>
         <1467110918.2493.9.camel@sipsolutions.net>
         <1cb3e2cc49b433fe5ed834a33adf64b6@codeaurora.org>
         <1470043740.3389.10.camel@sipsolutions.net>
         <579F4E4E.80103@candelatech.com>
         <8908f6e7bb8ca043fbeb07ee8b004e8f@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In the case of manual intervention by user, the firmware will check 
> three
> values - regulatory domain, automatic tx power and user entered
> value. 
> System
> will always cap to the minimum of these values and see to that we do
> not 
> exceed
> the regulatory power limits.

Fair enough.

> If there are no more comments I will resent this patch series after 
> rebase.

I suspect we should also have some kind of capability for all of this,
so it can be used reliably?

johannes
