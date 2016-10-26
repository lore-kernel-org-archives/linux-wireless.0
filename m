Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52194 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942393AbcJZM7A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 08:59:00 -0400
Message-ID: <1477486736.4059.36.camel@sipsolutions.net> (sfid-20161026_145916_438000_C3B998B7)
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if
 requested
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 14:58:56 +0200
In-Reply-To: <3164753.QVH0CDzpbV@prime>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
         <4116422.yZP7iyh9mq@prime> <1477319916.4085.29.camel@sipsolutions.net>
         <3164753.QVH0CDzpbV@prime>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-24 at 16:53 +0200, Simon Wunderlich wrote:
> [snip]
> 
> Again, no explicit "on installation" here, but there is also nothing
> saying  that we can not check/operate on other channels in the
> meantime. 

Yeah, ok.

> (NOTE: going off-channel while operating is a different topic).

Why do you think it's different?

Seems exactly the same to me, since you come back to the channel and
start sending without any new checking?

johannes
