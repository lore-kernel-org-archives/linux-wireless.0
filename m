Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2EKKMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 06:12:36 -0400
Message-ID: <1336731153.4310.20.camel@jlt3.sipsolutions.net> (sfid-20120511_121240_049398_F5B8C0CE)
Subject: Re: [RFC 2/2] cfg80211: provide channel to start_ap function
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <avinashapatil@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Date: Fri, 11 May 2012 12:12:33 +0200
In-Reply-To: <CAJwzM1=hFmaj-tA7ru2Li9c2EGL5wbPbcGoA6aws=f+dRNmvTA@mail.gmail.com> (sfid-20120511_120401_713989_11A9A313)
References: <20120510203021.240931880@sipsolutions.net>
	 <20120510203304.806786399@sipsolutions.net>
	 <CAJwzM1=KxQqGRu34C9N-SFcwY3ayVsLnP4BS4iOr7dFgO+qu3A@mail.gmail.com>
	 <1336730159.4310.16.camel@jlt3.sipsolutions.net>
	 <CAJwzM1=hFmaj-tA7ru2Li9c2EGL5wbPbcGoA6aws=f+dRNmvTA@mail.gmail.com>
	 (sfid-20120511_120401_713989_11A9A313)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-11 at 15:33 +0530, Avinash Patil wrote:
> How does mwifiex work with this? Is it easier/harder to do?
> 
> set_channel handler from cfg80211 is issued first where we set channel
> to FW. After that in start_ap, we set beacon, dtim interval, SSID,
> security etc and start AP.
> Its easier to move to new implementation, but unit testing and
> internal review of this patch may take some time and by then merge
> window may expire.

I'll have to let you sort this out with John. I don't know if he is
planning to merge either of our patches for 3.5.

If he picks up your code before mine though, be prepared that I'll just
resend my code fixing up mwifiex in the most simple way and will not
really be worried about your unit testing/internal review. If you want
to help me out though you could make a small patch that adjusts your
code to the new API and send it to me/the list separately from your
submission.

johannes

