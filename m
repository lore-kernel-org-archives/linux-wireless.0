Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41359 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbbAHO0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 09:26:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Y9E2w-0002Xy-2c
	for linux-wireless@vger.kernel.org; Thu, 08 Jan 2015 15:26:46 +0100
Message-ID: <1420727204.2029.7.camel@sipsolutions.net> (sfid-20150108_152650_896675_4DC29ED1)
Subject: Re: [PATCH 0/9] cfg80211/mac80211 statistics cleanups & features
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 08 Jan 2015 15:26:44 +0100
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145808_697234_0CC4B481)
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20141217_145808_697234_0CC4B481)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 14:57 +0100, Johannes Berg wrote:
> This series of patches consists of major cleanups to the statistics
> framework, and the following new features:
>  * non-channel-specific 'survey' data for allowing drivers to report
>    global radio statistics (like the newly added scan time)
>  * allow scan time reporting in survey
>  * include statistics in station delete event so a userspace process
>    listening can actually keep track of more global packet statistics
>  * allow drivers to report some statistics, which is needed e.g. when
>    beacon filtering is done, or similar (replacing get_rssi that the
>    TI driver used)

I applied these now. The per-rate statistics I've been building on top
is still WIP.

johannes

