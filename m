Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:34680 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab1KXVC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 16:02:29 -0500
Date: Thu, 24 Nov 2011 23:02:22 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 5/5] wireless: annotate drivers that do not support
 NL80211_TX_POWER_REG
Message-ID: <20111124210222.GA9929@jm.kir.nu> (sfid-20111124_220232_548432_5C6084D1)
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1322062858-15276-6-git-send-email-mcgrof@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1322062858-15276-6-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 10:40:58AM -0500, Luis R. Rodriguez wrote:
> brcm80211, iwmc3200wifi and mwifiex lack support for
> NL80211_TX_POWER_REG.

> diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
> +	case NL80211_TX_REG:

That would benefit from a test run with a compiler..
 
-- 
Jouni Malinen                                            PGP id EFC895FA
