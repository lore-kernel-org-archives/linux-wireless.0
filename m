Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57459 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757430AbcILKDs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:03:48 -0400
Message-ID: <1473674624.29016.4.camel@sipsolutions.net> (sfid-20160912_120453_493315_0276354E)
Subject: Re: [PATCH] mac80211: fix sequence number assignment for PS
 response frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 12:03:44 +0200
In-Reply-To: <afb51baf-ec2d-3600-9e5b-f406b9e836b7@nbd.name>
References: <20160904160059.66297-1-nbd@nbd.name>
         <1473674327.29016.3.camel@sipsolutions.net>
         <afb51baf-ec2d-3600-9e5b-f406b9e836b7@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Hm, I guess I didn't think of that. I guess this potential issue will
> go away once we get Toke's tx handler reorder patch fixed, rebased
> and integrated.
> 

I don't really see how that helps?

johannes
