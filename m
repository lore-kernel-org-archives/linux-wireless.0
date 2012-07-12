Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933913Ab2GLOPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 10:15:39 -0400
Message-ID: <1342102537.4531.24.camel@jlt3.sipsolutions.net> (sfid-20120712_161553_076723_A5503296)
Subject: Re: [PATCH v2] cfg80211: ignore channel state for stopped AP/mesh
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com
Date: Thu, 12 Jul 2012 16:15:37 +0200
In-Reply-To: <1342102202-21045-1-git-send-email-nbd@openwrt.org>
References: <1342102202-21045-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 16:10 +0200, Felix Fietkau wrote:
> Without this change, running AP + station on the same wiphy does not work
> since the commit "cfg80211: add channel checking for iface combinations".
> The stopped AP prevents the client from connecting to an AP on a different
> channel.

Applied, thanks.

johannes

