Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAFTBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 14:01:42 -0500
Message-ID: <1389034896.5891.41.camel@jlt4.sipsolutions.net> (sfid-20140106_200145_725965_A8C1EE48)
Subject: Re: [PATCH] cfg80211: fix wext-compat for getting retry value
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Kernel <linux-wireless@vger.kernel.org>
Date: Mon, 06 Jan 2014 20:01:36 +0100
In-Reply-To: <1389025571-309-1-git-send-email-royujjal@gmail.com> (sfid-20140106_172637_952552_71FB699C)
References: <1389025571-309-1-git-send-email-royujjal@gmail.com>
	 (sfid-20140106_172637_952552_71FB699C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 21:56 +0530, Ujjal Roy wrote:
> While getting the retry limit, wext-compat returns the value
> without updating the flag for retry->flags is 0. Also in this
> case, it updates long retry flag when short and long retry
> value are unequal.
> 
> So, iwconfig never showing "Retry short limit" and showing
> "Retry long limit" when both values are unequal.
> 
> Updated the flags and corrected the condition properly.

Looks fine, applied. Who cares though? :)

johannes

