Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49600 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425285AbdD1JKC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 05:10:02 -0400
Message-ID: <1493370600.2431.2.camel@sipsolutions.net> (sfid-20170428_111007_408089_30EA94E2)
Subject: Re: [PATCH 1/5] mac80211: make rate control tx status API more
 extensible
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: thomas@net.t-labs.tu-berlin.de
Date: Fri, 28 Apr 2017 11:10:00 +0200
In-Reply-To: <20170426151139.87304-1-nbd@nbd.name>
References: <20170426151139.87304-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've applied patches 1-3.

Patch 5 is missing your S-o-b (since you sent it to me), but regardless
of that I'd like to actually see the usage (in minstrel?) with the API.

johannes
