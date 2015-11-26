Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38260 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbKZRUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:20:11 -0500
Message-ID: <1448558408.2167.30.camel@sipsolutions.net> (sfid-20151126_182015_286242_AAA7B732)
Subject: Re: [PATCH v2 1/2] cfg80211: Add support for aborting an ongoing
 scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt <usdutt@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	vkanchan@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Thu, 26 Nov 2015 18:20:08 +0100
In-Reply-To: <1446212690-326-1-git-send-email-usdutt@qti.qualcomm.com>
References: <1446212690-326-1-git-send-email-usdutt@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-30 at 19:14 +0530, Sunil Dutt wrote:
> From: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
> 
> Implement new functionality for aborting an ongoing scan.
> 
> Add NL80211_CMD_ABORT_SCAN to the nl80211 interface. After
> aborting the scan, driver shall provide the scan status by
> calling cfg80211_scan_done().
> 
Applied, I made some changes to allow this to be used on wdev, not just
netdev and cleaned up/shuffled the code a bit.

johannes
