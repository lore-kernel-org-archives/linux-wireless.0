Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3K2WOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 17:14:51 -0500
Message-ID: <1385763288.5149.0.camel@jlt4.sipsolutions.net> (sfid-20131129_231454_968638_B6B9409A)
Subject: Re: WARNING: CPU: 2 PID: 827 at net/wireless/sme.c:795
 cfg80211_roamed+0x97/0xa0 [cfg80211]()
From: Johannes Berg <johannes@sipsolutions.net>
To: Krzysztof Kolasa <kkolasa@winsoft.pl>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Nov 2013 23:14:48 +0100
In-Reply-To: <5298EA48.1050206@winsoft.pl> (sfid-20131129_204934_655986_57747678)
References: <5298EA48.1050206@winsoft.pl>
	 (sfid-20131129_204934_655986_57747678)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-29 at 20:26 +0100, Krzysztof Kolasa wrote:

> cfg80211_roamed+0x97/0xa0 [cfg80211]
> wl_bss_connect_done.isra.18+0xa3/0x1b0 [wl]
> wl_notify_connect_status+0x176/0x340 [wl]

Not sure why we should care about proprietary drivers ...

johannes

