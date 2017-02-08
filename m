Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42540 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752899AbdBHJvC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:51:02 -0500
Message-ID: <1486544774.4603.12.camel@sipsolutions.net> (sfid-20170208_105212_376843_C3DA29E4)
Subject: Re: [PATCH] cfg80211: make rdev assignment clearer in
 nl80211_testmode_dump()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 08 Feb 2017 10:06:14 +0100
In-Reply-To: <20170207201356.4752-1-luca@coelho.fi>
References: <20170207201356.4752-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-07 at 22:13 +0200, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Avoid assigning rdev to NULL when we already have it and getting it
> again from the wiphy index, by moving this code to relevant if block.

Applied.

johannes
