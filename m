Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60239 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaFCTvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 15:51:42 -0400
Message-ID: <1401825089.4157.39.camel@jlt4.sipsolutions.net> (sfid-20140603_215144_894951_129FF0BD)
Subject: Re: [PATCH v7 0/5] cfg/mac80211: implement multi-vif csa
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Tue, 03 Jun 2014 21:51:29 +0200
In-Reply-To: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com> (sfid-20140529_094141_575159_9ECE86F3)
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140529_094141_575159_9ECE86F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-29 at 09:34 +0200, Michal Kazior wrote:
> Hi,
> 
> Here's yet again a re-spin of my multi-vif csa
> patches. Hopefully I got everything right this
> time..

So there seems to be some discussion on patch 1, the rest looks fine (to
me, I'll let Luca chime in if he wants)

> I've delibarately not included documentation
> fixes. I think we can handle this with follow up
> patches.

Fair enough.

johannes

