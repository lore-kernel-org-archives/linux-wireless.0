Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38218 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754111AbcLLK2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 05:28:00 -0500
Message-ID: <1481538476.4067.2.camel@sipsolutions.net> (sfid-20161212_112803_342701_3B2A8D18)
Subject: Re: [PATCH] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Dec 2016 11:27:56 +0100
In-Reply-To: <CAOq732Lvqez5mNne9YAk8aTrZyAQsxxL6pSwD9EkB4V0t2mLrg@mail.gmail.com> (sfid-20161212_110152_498754_AEAADC19)
References: <20161212002911.5541-1-andrew.zaborowski@intel.com>
         <8E332BC1-F05E-4771-ABA4-BD6C59449125@holtmann.org>
         <CAOq732Lvqez5mNne9YAk8aTrZyAQsxxL6pSwD9EkB4V0t2mLrg@mail.gmail.com>
         (sfid-20161212_110152_498754_AEAADC19)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-12 at 11:01 +0100, Andrew Zaborowski wrote:
> On 12 December 2016 at 08:21, Marcel Holtmann <marcel@holtmann.org>
> wrote:
> > 
> > > 
> > > Disconnect or deauthenticate when the owning socket is closed if
> > > this
> > > flag is supplied to CMD_CONNECT or CMD_AUTHENTICATE.  This may be
> > > used
> > > to ensure userspace daemon doesn't leave an unmanaged connection
> > > behind.
> > 
> > I think you have a typo here. The CMD_AUTHENTICATE should be
> > CMD_ASSOCIATE?
> 
> Good point, let me change this and resend.

It'd be helpful if you could follow normal practice and add a v2/v3/...
tag to your [PATCH] tag, that helps knowing which one's the latest.

johannes
