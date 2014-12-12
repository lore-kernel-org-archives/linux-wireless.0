Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33131 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967609AbaLLM3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:29:24 -0500
Message-ID: <1418387359.2470.29.camel@sipsolutions.net> (sfid-20141212_132927_905116_584B9442)
Subject: Re: [PATCH] cfg80211: don't WARN about two consecutive Country IE
 hint
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: mcgrof@suse.com, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Date: Fri, 12 Dec 2014 13:29:19 +0100
In-Reply-To: <1417506805-20361-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1417506805-20361-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-02 at 09:53 +0200, Emmanuel Grumbach wrote:
> This can happen and there is no point in added more
> detection code lower in the stack. Catching these in one
> single point (cfg80211) is enough. Stop WARNING about this
> case.

Applied.

johannes

