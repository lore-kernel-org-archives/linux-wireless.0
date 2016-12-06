Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51032 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752963AbcLFHQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Dec 2016 02:16:03 -0500
Message-ID: <1481008560.6610.3.camel@sipsolutions.net> (sfid-20161206_081635_904022_191A8547)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 06 Dec 2016 08:16:00 +0100
In-Reply-To: <584588A2.9090006@gmail.com> (sfid-20161205_163253_374975_2294902F)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
         <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
         <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
         (sfid-20161205_163253_374975_2294902F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-05 at 09:32 -0600, Denis Kenzior wrote:

> To what purpose?  That's like saying that maybe a socket should be
> kept open in case an application crashes.

That socket would be useless, so no, that's not comparable at all. It's
more like saying the disk should be unmounted once 'mount' exits ;-)

Anyway ... I'm not even super against this patch, but you need to fix
things:
 * this is actually wrong for authenticate - I'll let you figure out
   why by yourself
 * you need to teach people to write useful commit messages

johannes
