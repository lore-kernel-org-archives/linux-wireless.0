Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab3IZRo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 13:44:26 -0400
Message-ID: <1380217458.4592.0.camel@jlt4.sipsolutions.net> (sfid-20130926_194429_669683_4DE83582)
Subject: Re: [PATCH] cfg80211: fix warning when using WEXT for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Thu, 26 Sep 2013 19:44:18 +0200
In-Reply-To: <1380210928-6604-1-git-send-email-br1@einfach.org>
References: <1380210928-6604-1-git-send-email-br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-26 at 16:55 +0100, Bruno Randolf wrote:
> Fix kernel warning when using WEXT for configuring ad-hoc mode,
> e.g.  "iwconfig wlan0 essid test channel 1"
> 
> [ 1003.460000] WARNING: at net/wireless/chan.c:373
> cfg80211_chandef_usable+0x50/0x21c [cfg80211]()
> 
> The warning is caused by an uninitialized variable center_freq1.

Applied.

johannes

