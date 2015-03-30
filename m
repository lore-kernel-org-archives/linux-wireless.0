Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45535 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbbC3IRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:17:47 -0400
Message-ID: <1427703464.26117.2.camel@sipsolutions.net> (sfid-20150330_101752_011560_3914C8E9)
Subject: Re: [PATCH 0/4] mac80211: inform the low level driver about events
 in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 10:17:44 +0200
In-Reply-To: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-16 at 23:23 +0200, Emmanuel Grumbach wrote:
> This can be useful to know what is happening in mac80211
> from the low level driver without guessing from mac80211's
> callbacks.
> This can be used for error detection (too many deauths)
> and trigger recovery / debug flows based on that
> information.
> Another possibility is to change parameters that are not
> controlled by mac80211 based on this. For example, after
> a few association failures, a device may change its BT
> Coexist scheme or modify the time sharing between its
> vifs.
> 
> I use these patches in iwlwifi for debug only (currently).
> This allows me to collect firmware debug data upon
> authentication failure / deauth Rx etc...

Applied all four.

johannes

