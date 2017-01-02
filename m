Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37108 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750996AbdABKpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 05:45:33 -0500
Message-ID: <1483353931.4596.3.camel@sipsolutions.net> (sfid-20170102_114536_764601_58DDDC32)
Subject: Re: cfg80211: add set/get link loss profile
From: Johannes Berg <johannes@sipsolutions.net>
To: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Mon, 02 Jan 2017 11:45:31 +0100
In-Reply-To: <58a1b983-6688-8b3e-81cb-83c62b46abbf@codeaurora.org>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
         <1480344742.8107.63.camel@sipsolutions.net>
         <58a1b983-6688-8b3e-81cb-83c62b46abbf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-19 at 12:58 +0200, Lazar, Alexei Avshalom wrote:

> > What you're doing here is *extremely* vague. No definitions of what
> > this means, no description of how it's intended to be implemented,
> > no note even on whether or not this is for full-MAC chips or not,
> > etc.
> > 
> 
> The patch is intended for full-MAC chips and I will update the commit
> message to include more details.
> 
> > At least for mac80211, we can define signals to userspace regarding
> > "link quality" and make decisions in wpa_s then?
> > 
> 
> The policy is offloaded today to the FW and the decision being made
> by the FW.
> We are only modifying the behavior and not making the decision.

Fair enough, but I stand by saying that it's extremely vague - how
could userspace possibly know what "level" to pick, if you don't give
it any information about what the levels really mean?

johannes
