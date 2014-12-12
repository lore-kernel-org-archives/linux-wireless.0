Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32902 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966072AbaLLLdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:33:42 -0500
Message-ID: <1418384019.2470.18.camel@sipsolutions.net> (sfid-20141212_123345_988479_E3320618)
Subject: Re: [PATCH] nl80211: check matches array length before acessing it
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 12:33:39 +0100
In-Reply-To: <1417426329-16099-1-git-send-email-luca@coelho.fi>
References: <1417426329-16099-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-01 at 11:32 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> If the userspace passes a malformed sched scan request (or a net
> detect wowlan configuration) by adding a NL80211_ATTR_SCHED_SCAN_MATCH
> attribute without any nested matchsets, a NULL pointer dereference
> will occur.  Fix this by checking that we do have matchsets in our
> array before trying to access it.

Applied, thanks.

johannes

