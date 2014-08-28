Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54541 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbaH1UFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 16:05:35 -0400
Message-ID: <1409256330.2505.13.camel@jlt4.sipsolutions.net> (sfid-20140828_220541_668937_EC9F2B50)
Subject: Re: [PATCH] mac80211: fix offloaded BA session traffic after hw
 restart
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Aug 2014 22:05:30 +0200
In-Reply-To: <1409225636-23923-1-git-send-email-michal.kazior@tieto.com> (sfid-20140828_134349_843937_D5B6A6CC)
References: <1409225636-23923-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140828_134349_843937_D5B6A6CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-08-28 at 13:33 +0200, Michal Kazior wrote:

> Instead of last_seq pick seqno of a first Rxed
> frame of a given BA session.

Any way to do this without touching the RX path? It's kinda a hotpath :)

johannes

