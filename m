Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58626 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbcFIJst (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 05:48:49 -0400
Message-ID: <1465465725.3442.9.camel@sipsolutions.net> (sfid-20160609_114852_933367_5F580E36)
Subject: Re: [PATCHv4 3/5] mac80211: add debug knobs for fair queuing
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: dave.taht@gmail.com, make-wifi-fast@lists.bufferbloat.net,
	codel@lists.bufferbloat.net, apenwarr@gmail.com
Date: Thu, 09 Jun 2016 11:48:45 +0200
In-Reply-To: <1462446039-1070-4-git-send-email-michal.kazior@tieto.com> (sfid-20160505_125852_765481_CD41B2B4)
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	 <1462446039-1070-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160505_125852_765481_CD41B2B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-05-05 at 13:00 +0200, Michal Kazior wrote:
> This adds a few debugfs entries and a module
> parameter to make it easier to test, debug and
> experiment.
> 
I removed the module parameter, I don't really like that. Maybe it can
be replaced by a mac80211 debugfs file, that already exists when
mac80211 is loaded, outside the context of a device, so it can be set
before loading the driver?

johannes
