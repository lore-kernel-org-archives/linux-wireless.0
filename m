Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42111 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750967AbcINGGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 02:06:15 -0400
Message-ID: <1473833168.4423.3.camel@sipsolutions.net> (sfid-20160914_080651_574258_44FD74B5)
Subject: Re: [PATCH] mac80211: allow driver to handle packet-loss mechanism
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 14 Sep 2016 08:06:08 +0200
In-Reply-To: <e968a9083a9f5fd7e9c04d563288b229@codeaurora.org>
References: <20160906065624.4062-1-rmanohar@qti.qualcomm.com>
         <1473684288.29016.38.camel@sipsolutions.net>
         <e968a9083a9f5fd7e9c04d563288b229@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > The way you describe this it sounds like somehow you'll be
> > reporting the indication to userspace from the driver; but you do
> > not, and cannot do that. The description seems thus misleading?
> > 
> Sorry for confusion.. The idea is that driver will report low ack
> status by ieee80211_report_low_ack and if driver wants to completely
> rely on firmware algorithm, then this flag will be used to bypass
> mac80211 packet loss mechanism. does it make sense?

Oh, so you *can* already do that. Please just say that in the commit
message.

johannes
