Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57416 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756905AbcILJ4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:56:40 -0400
Message-ID: <1473674196.29016.1.camel@sipsolutions.net> (sfid-20160912_120114_389512_9D5DA3E4)
Subject: Re: [PATCH] mac80211: fix tim recalculation after PS response
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 11:56:36 +0200
In-Reply-To: <20160828111037.46801-1-nbd@nbd.name>
References: <20160828111037.46801-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-08-28 at 13:10 +0200, Felix Fietkau wrote:
> Handle the case where the mac80211 intermediate queues are empty and
> the driver has buffered frames
> 
Applied.

johannes
