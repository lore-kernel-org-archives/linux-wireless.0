Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34827 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938700AbcJSOOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:14:10 -0400
Message-ID: <1476872250.10092.1.camel@sipsolutions.net> (sfid-20161019_161439_703029_FBB7B02E)
Subject: Re: [PATCH 0/7] patches for mac80211/cfg80211 2016-10-18
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 12:17:30 +0200
In-Reply-To: <20161018201213.18873-1-luca@coelho.fi>
References: <20161018201213.18873-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 23:12 +0300, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Hi Johannes,
> 
> Here are a few patches for mac80211/cfg80211 from our internal tree.
> You're probably familiar with most of them, I'm just adding a cover
> letter to make it easier for you to reply "Applied all"
> (hopefully).:)

Heh, ok, done; all are in mac80211-next, I didn't think they were
important for mac80211. My NULL deref fix is debatable, but the
hardware that supports this isn't shipping yet, and will never work
with this kernel due to firmware release/compatibility anyway.

Also the NAN patch you sent separately.

johannes
