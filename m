Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63445 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0FLR2t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 13:28:49 -0400
Subject: Re: [PATCH 4/7] ath9k_hw: remove ATH9K_CAP_TKIP_SPLIT
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	linville@tuxdriver.com
In-Reply-To: <1276356154-66545-4-git-send-email-nbd@openwrt.org>
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
	 <1276356154-66545-2-git-send-email-nbd@openwrt.org>
	 <1276356154-66545-3-git-send-email-nbd@openwrt.org>
	 <1276356154-66545-4-git-send-email-nbd@openwrt.org>
Content-Type: text/plain
Date: Sat, 12 Jun 2010 13:28:43 -0400
Message-Id: <1276363723.2625.7.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-06-12 at 17:22 +0200, Felix Fietkau wrote:
> This is only used as a workaround for an issue in one specific hw revision.

Is that workaround needed for both PCI and USB?  If not,
common->splitmic should not be needed and further cleanup should be
possible.

-- 
Regards,
Pavel Roskin
