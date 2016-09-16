Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59398 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753510AbcIPMun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 08:50:43 -0400
Message-ID: <1474030240.5481.7.camel@sipsolutions.net> (sfid-20160916_145045_930851_7494357B)
Subject: Re: [PATCH] cfg80211: add helper to find an IE that matches a
 byte-array
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Sep 2016 14:50:40 +0200
In-Reply-To: <20160915151509.30840-1-luca@coelho.fi>
References: <20160915151509.30840-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-15 at 18:15 +0300, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> There are a few places where an IE that matches not only the EID, but
> also other bytes inside the element, needs to be found.  To simplify
> that and reduce the amount of similar code, implement a new helper
> function to match the EID and an extra array of bytes.
> 
Applied.

johannes
