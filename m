Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48478 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751216AbdC2QwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 12:52:07 -0400
Message-ID: <1490806324.7948.23.camel@sipsolutions.net> (sfid-20170329_185210_895707_74DD2738)
Subject: Re: [PATCH v3 3/4] mac80211-hwsim: add rate-limited debugging for
 rx-netlink
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 18:52:04 +0200
In-Reply-To: <5c86dcbe-7a7b-47cd-4c77-d56e249369e0@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
         <1490311578-18926-3-git-send-email-greearb@candelatech.com>
         <1490777219.7948.11.camel@sipsolutions.net>
         <5c86dcbe-7a7b-47cd-4c77-d56e249369e0@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > >  		wiphy_debug(hw->wiphy,
> > > -			    "%s (freq=0 idle=%d ps=%d
> > > smps=%s)\n",
> > > +			    "%s (no-chandef-chan freq=0 idle=%d
> > > ps=%d smps=%s)\n",
> > 
> > This seems unrelated?
> 
> It can be cut out of the patch.  Want me to re-send?

No objection about that change itself, but I don't think it belongs
into the same patch, so yes, please do.

johannes
