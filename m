Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48468 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752256AbdC2QvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 12:51:15 -0400
Message-ID: <1490806271.7948.22.camel@sipsolutions.net> (sfid-20170329_185119_737306_D5C16A08)
Subject: Re: [PATCH v3 1/4] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 18:51:11 +0200
In-Reply-To: <260bf7e1-5ff2-709a-419b-df54b80c87f0@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
         <1490776922.7948.9.camel@sipsolutions.net>
         <260bf7e1-5ff2-709a-419b-df54b80c87f0@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The patch appeared to solve my problem, and it seems an improvement
> over what is there currently.  Whoever wants it to support even more
> things can add that in the future?

Yes, that's kinda true. However, it also means that wmediumd (or
similar) would have to support the two APIs. It'd be simpler for them
to just have to support a single one, no?

johannes
