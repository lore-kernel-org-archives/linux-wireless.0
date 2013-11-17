Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3KQJlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 04:41:39 -0500
Message-ID: <1384681297.14795.15.camel@jlt4.sipsolutions.net> (sfid-20131117_104141_979616_82EF3B4F)
Subject: Re: [PATCH] cfg80211: fix reporting 5/10 MHz support to user space
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 17 Nov 2013 10:41:37 +0100
In-Reply-To: <1384005474-86844-1-git-send-email-nbd@openwrt.org>
References: <1384005474-86844-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-11-09 at 14:57 +0100, Felix Fietkau wrote:
> nla_put_flag needs a real nl80211 attribute id, not a wiphy flag bit

Applied to mac80211-next, the 3.12/3.13 situation is a bit more
complicated so I'll disable 5/10 MHz support there.

johannes

