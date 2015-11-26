Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38036 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbbKZQnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 11:43:55 -0500
Message-ID: <1448556233.2167.19.camel@sipsolutions.net> (sfid-20151126_174358_211134_E6A33604)
Subject: Re: [PATCH v2] nl80211: clarify NL80211_ATTR_SCHED_SCAN_DELAY usage
 with net-detect
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: samueltan@google.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2015 17:43:53 +0100
In-Reply-To: <1447064257-723-1-git-send-email-luca@coelho.fi>
References: <1447064257-723-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-09 at 12:17 +0200, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> In this attribute's documentation, it was not clear whether the delay
> started counting when WoWLAN net-detect was enabled or when the
> system
> was suspended.  The correct answer is that it starts when the system
> suspends (which is when, in practice, the scan is
> scheduled).  Clarify
> that in the nl80211.h documentation.
> 
Applied.

johannes
