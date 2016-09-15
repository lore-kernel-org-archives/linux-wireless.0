Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51170 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933335AbcIOIt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 04:49:28 -0400
Message-ID: <1473929362.25838.0.camel@sipsolutions.net> (sfid-20160915_105054_151165_698709C2)
Subject: Re: [PATCH v5] cfg80211: Add support to configure a beacon data rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Thu, 15 Sep 2016 10:49:22 +0200
In-Reply-To: <1473927421.4423.38.camel@sipsolutions.net> (sfid-20160915_101917_590850_04C3DE8A)
References: <1473854924-10352-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1473927421.4423.38.camel@sipsolutions.net>
         (sfid-20160915_101917_590850_04C3DE8A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-15 at 10:17 +0200, Johannes Berg wrote:
> On Wed, 2016-09-14 at 17:38 +0530, Purushottam Kushwaha wrote:
> > 
> > This allows an option to configure a single beacon tx rate (u8) for
> > an AP.
> > 
> Applied.
> 

Actually. Moved to the pending branch - shouldn't we have some feature
flags here to indicate that the driver actually supports this?

johannes
