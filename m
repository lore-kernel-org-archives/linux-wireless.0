Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57168 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJIJZg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:25:36 -0400
Message-ID: <1412846729.1828.31.camel@jlt4.sipsolutions.net> (sfid-20141009_112539_868708_177CF1E4)
Subject: Re: [PATCH v2 1/7] nl80211: sanity check the channel switch counter
 value
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Thu, 09 Oct 2014 11:25:29 +0200
In-Reply-To: <1412750920-15392-2-git-send-email-luca@coelho.fi>
References: <1412750920-15392-1-git-send-email-luca@coelho.fi>
	 <1412750920-15392-2-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-08 at 09:48 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> The nl80211 channel switch count attribute
> (NL80211_ATTR_CH_SWITCH_COUNT) is specified as u32, but the
> specification uses u8 for the counter.  To make sure strange things
> don't happen without informing the user, sanity check the value and
> return -EINVAL if it doesn't fit in u8.

Applied for 3.18.

johannes

