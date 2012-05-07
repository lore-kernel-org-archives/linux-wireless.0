Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2EGGeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 02:34:15 -0400
Message-ID: <1336372450.4325.0.camel@jlt3.sipsolutions.net> (sfid-20120507_083423_227198_95AC482E)
Subject: Re: WARNING: at net/mac80211/iface.c:162
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Date: Mon, 07 May 2012 08:34:10 +0200
In-Reply-To: <4FA709B3.4030404@lwfinger.net> (sfid-20120507_013135_141792_546F01AB)
References: <4FA709B3.4030404@lwfinger.net>
	 (sfid-20120507_013135_141792_546F01AB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-05-06 at 18:30 -0500, Larry Finger wrote:
> Hi,
> 
> I am getting the following warning from the latest wireless-testing system:
> 
>   ------------[ cut here ]------------
>   WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues+0x119/0x130 
> [mac80211]()


>       if (WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
> 
> The warning is triggered for i, n_queues, and sdata->vif.hw_queue[i] all equal to 1.

Is this a driver with just a single queue by any chance? I never tested
that and probably forgot to set those up correctly.

johannes

