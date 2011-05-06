Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1EFIjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 04:39:45 -0400
Subject: Re: [PATCH 2.6.39] mac80211: always clear PS filtering for non-AP
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	greearb@candelatech.com
In-Reply-To: <1304642474-32935-1-git-send-email-nbd@openwrt.org>
References: <1304642474-32935-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 10:39:42 +0200
Message-ID: <1304671182.3595.2.camel@jlt3.sipsolutions.net> (sfid-20110506_103954_170184_C77E6C9B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-06 at 02:41 +0200, Felix Fietkau wrote:
> PS filtering is only useful in AP mode and by setting the flags in mac80211,
> vif mode checks do not have to be added to every single driver supporting
> this.
> Fixes part of a regression introduced in commit 93ae2dd2
> "ath9k: assign keycache slots to unencrypted stations"

I guess for GO powersave this might need to change but it seems nobody
has thought about implementing that yet anyway :)

johannes

