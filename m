Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55640 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbbKCKQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 05:16:55 -0500
Message-ID: <1446545810.29010.12.camel@sipsolutions.net> (sfid-20151103_111706_492163_97767BBE)
Subject: Re: [PATCH] mac80211: Handle sleep requirements for channel context
 ops.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Nov 2015 11:16:50 +0100
In-Reply-To: <1446227175-28942-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20151030_184629_039806_0387A389)
References: <1446227175-28942-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20151030_184629_039806_0387A389)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-30 at 23:16 +0530, Chaitanya T K wrote:
> From: Chaitanya T K <chaitanya.mgit@gmail.com>
> 
> Channel context OPs can sleep, so add might_sleep() and
> also document sleep requirements for those OPs.
> 
Applied.

johannes
