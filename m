Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45539 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbbC3ISh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:18:37 -0400
Message-ID: <1427703514.26117.3.camel@sipsolutions.net> (sfid-20150330_101843_908499_8E32A8BE)
Subject: Re: [PATCH] nl80211: add net-detect delay to wowlan info
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 10:18:34 +0200
In-Reply-To: <1426602961-9484-1-git-send-email-luca@coelho.fi>
References: <1426602961-9484-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 16:36 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Pass the initial net-detect delay (NL80211_ATTR_SCHED_SCAN_DELAY)
> attribute in the WoWLAN info response.
> 
> Additionally, remove a bogus TODO comment.

Applied.

johannes

