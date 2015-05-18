Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51736 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbbERJFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 05:05:30 -0400
Message-ID: <1431939927.2719.0.camel@sipsolutions.net> (sfid-20150518_110533_666367_2B1AAAA6)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused
 by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: chaitanya.mgit@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 May 2015 11:05:27 +0200
In-Reply-To: <1431939609-7261-1-git-send-email-chaitanya.mgit@gmail.com>
References: <chaitanya.mgit@gmail.com>
	 <1431939609-7261-1-git-send-email-chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-18 at 14:30 +0530, chaitanya.mgit@gmail.com wrote:
> From: Chaitanya T K <chaitanya.tata@imgtec.com>
> 
> If we receive suspend after TX path has executed
> dynamic ps disable work, the driver will be in 
> ACTIVE state during suspend and even after it 
> resumes. 
> 
> As before suspend all data packets are flushed
> it is safe to put the driver in to sleep for
> optimal power during suspend or up on resume.

Please stop resending this patch a few times a day without indicating
any changes.

I'm going to ignore it for a few days now until this settles down.

johannes

