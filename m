Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47610 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbaEHKVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 06:21:51 -0400
Message-ID: <1399543075.9163.0.camel@jlt4.sipsolutions.net> (sfid-20140508_122154_855411_A0031E61)
Subject: Re: [PATCH v5] mac80211: disconnect iface if CSA unexpectedly fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Thu, 08 May 2014 11:57:55 +0200
In-Reply-To: <1399533002-3681-1-git-send-email-michal.kazior@tieto.com> (sfid-20140508_091657_689819_7BD424B1)
References: <1397049062-24177-5-git-send-email-michal.kazior@tieto.com>
	 <1399533002-3681-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140508_091657_689819_7BD424B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-08 at 09:10 +0200, Michal Kazior wrote:
> It doesn't make much sense to leave a crippled
> interface running.
> 
> As a side effect this will unblock tx queues with
> CSA reason immediately after failure instead of
> until after userspace requests interface to stop.
> 
> This also gives userspace an opportunity to
> indirectly see CSA failure.

Applied, I did a small cleanup to the new function.

johannes

