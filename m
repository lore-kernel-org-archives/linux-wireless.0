Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45246 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaFWJ3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 05:29:48 -0400
Message-ID: <1403515774.4418.8.camel@jlt4.sipsolutions.net> (sfid-20140623_113003_798742_3C1E645B)
Subject: Re: [PATCH] cfg80211: fix elapsed_jiffies calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Jun 2014 11:29:34 +0200
In-Reply-To: <1402999622-27880-1-git-send-email-eliad@wizery.com> (sfid-20140617_120711_840792_91AD4ABC)
References: <1402999622-27880-1-git-send-email-eliad@wizery.com>
	 (sfid-20140617_120711_840792_91AD4ABC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-17 at 13:07 +0300, Eliad Peller wrote:
> MAX_JIFFY_OFFSET has no meaning when calculating the
> elapsed jiffies, as jiffies run out until ULONG_MAX.
> 
> This miscalculation results in erroneous values
> in case of a wrap-around.

Applied, thanks.

johannes

