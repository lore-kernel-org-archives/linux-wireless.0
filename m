Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2CAOcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:32:20 -0500
Subject: Re: [PATCH 2/2] mac80211: use compare_ether_addr on MAC addresses
 instead of memcmp
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1330611729-68484-2-git-send-email-nbd@openwrt.org>
References: <1330611729-68484-1-git-send-email-nbd@openwrt.org>
	 <1330611729-68484-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 15:32:18 +0100
Message-ID: <1330612338.3623.10.camel@jlt3.sipsolutions.net> (sfid-20120301_153223_598905_F35D6AA6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-01 at 15:22 +0100, Felix Fietkau wrote:
> Because of the constant size and guaranteed 16 bit alignment, the inline
> compare_ether_addr function is much cheaper than calling memcmp.

Guess I'm in for some rebasing :-)

> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

