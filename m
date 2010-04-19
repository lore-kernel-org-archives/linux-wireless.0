Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59094 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0DSTEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 15:04:14 -0400
Subject: Re: [PATCH v2 1/9] ath9k: check for specific rx stuck conditions
 and recover from them
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
In-Reply-To: <1271699857-12366-1-git-send-email-nbd@openwrt.org>
References: <1271699857-12366-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain
Date: Mon, 19 Apr 2010 15:04:12 -0400
Message-Id: <1271703852.19879.1.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-19 at 19:57 +0200, Felix Fietkau wrote:
> +		if ((reg & 0x7E7FFFEF) == 0x00702400)
> +			continue;
> +
> +		switch (reg & 0x7E000B00) {
> +		case 0x1E000000:
> +		case 0x52000B00:
> +		case 0x18000B00:
> +			continue;

Where did you get all that magic?  If it's from Atheros documentation,
maybe you could give those numbers descriptive names?

-- 
Regards,
Pavel Roskin
