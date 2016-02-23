Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59117 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbcBWKC3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:02:29 -0500
Message-ID: <1456221745.2041.3.camel@sipsolutions.net> (sfid-20160223_110236_455654_27C6A610)
Subject: Re: [PATCH] cfg80211: fix faulty variable initialization in
 ieee80211_amsdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 11:02:25 +0100
In-Reply-To: <1454937926-74516-1-git-send-email-nbd@openwrt.org>
References: <1454937926-74516-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-08 at 14:25 +0100, Felix Fietkau wrote:
> reuse_skb is set to true if the code decides to use the last segment.
> Fixes a memory leak
> 
Applied.

johannes
