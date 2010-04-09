Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20304 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab0DIU3F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:29:05 -0400
Subject: Re: [PATCH 011/102] ath9k_hw: add some comments for
 ath9k_set_power_network_sleep()
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1270754858-26266-12-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
	 <1270754858-26266-12-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Fri, 09 Apr 2010 16:29:02 -0400
Message-Id: <1270844942.23853.28.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 15:26 -0400, Luis R. Rodriguez wrote:

> +/*
> + * Notify Power Management is enabled in self-generating
> + * frames. If request, set power mode of chip to
> + * auto/normal.  Duration in units of 128us (1/8 TU).
> + */
>  static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)

Maybe "Notify that power management is enabled"?
Maybe "If requested"?

What is setChip?  Where is duration set?

-- 
Regards,
Pavel Roskin
