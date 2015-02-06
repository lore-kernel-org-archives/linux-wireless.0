Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45488 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbBFTLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 14:11:05 -0500
Message-ID: <1423249860.2037.28.camel@sipsolutions.net> (sfid-20150206_201109_295520_CA6B1218)
Subject: Re: [PATCH] cfg80211: add debugfs VHT80 allow map
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@qti.qualcomm.com,
	vthiagar@qti.qualcomm.com
Date: Fri, 06 Feb 2015 20:11:00 +0100
In-Reply-To: <1423204546-22872-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1423204546-22872-1-git-send-email-arnagara@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-06 at 12:05 +0530, Ashok Raj Nagarajan wrote:
> Here is a output of this debugfs entry
> 
> root@OpenWrt:/# cat /sys/kernel/debug/ieee80211/phy0/vht80allow_map
> 2412 VHT80 N

I'm not sure I see much point in this, in fact we could remove the HT40
one?

We expose this data to userspace, so you could change 'iw' to print it
when dumping the list of channels in 'iw list' or similar.

johannes

