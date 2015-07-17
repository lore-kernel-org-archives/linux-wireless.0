Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52899 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbbGQNfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:35:06 -0400
Message-ID: <1437140104.1933.19.camel@sipsolutions.net> (sfid-20150717_153521_403954_BEC1B1E9)
Subject: Re: pull-request: mac80211 2015-07-17
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
Date: Fri, 17 Jul 2015 15:35:04 +0200
In-Reply-To: <1437139894.1933.16.camel@sipsolutions.net> (sfid-20150717_153149_337845_B05B138A)
References: <1437139894.1933.16.camel@sipsolutions.net>
	 (sfid-20150717_153149_337845_B05B138A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-17 at 15:31 +0200, Johannes Berg wrote:
> Hi Dave,
> 
> We've accumulated some wireless fixes, please pull. Arik's fix is a 
> bit
> bigger than I might like, but it fixes a real locking issue and we
> didn't really see a good way to make a smaller version.
> 
> Let me know if there's any problem.

Also, I'm going to be on vacation starting Tuesday, back on August 10.

I'm merging things to mac80211-next, but I'll hold the pull request
until after I return so I can deal with any possible issues in net-next
more quickly.

Kalle has graciously agreed to handle any urgent bugfixes to mac80211
while I'm out, and will probably send them to you as patches (if
necessary.)

johannes
