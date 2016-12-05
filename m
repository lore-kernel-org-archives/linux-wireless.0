Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43442 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbcLEO6W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:58:22 -0500
Message-ID: <1480949899.31788.34.camel@sipsolutions.net> (sfid-20161205_155824_650603_A91753C0)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 15:58:19 +0100
In-Reply-To: <58457FEA.4030305@gmail.com> (sfid-20161205_155540_425685_7615F26E)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
         (sfid-20161205_155540_425685_7615F26E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Detecting it is easy, sure.  But I'm a bit lost on how you propose
> to 
> 'use' it.  The connection is active up until the next rekey
> event.  If 
> rekey offloading is supported, then this might never involve user
> space. 
>   But if it isn't (and I can't get rekey offload to work on any
> recent 
> kernel I tried) then how do you propose userspace obtains the rekey 
> counter, or the various keys used in the connection?
> 
> What about all the other state information?  FT, Pre-Authentication,
> etc?

Well, no, that'd only work with an open connection :)

johannes
