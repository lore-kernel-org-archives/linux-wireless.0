Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44891 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933038Ab0DHVSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:18:09 -0400
Subject: Re: [PATCH 007/102] ath9k_hw: AR9003 does not have AR_RC_AHB skip
 its setting
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1270754858-26266-8-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
	 <1270754858-26266-8-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Thu, 08 Apr 2010 17:18:08 -0400
Message-Id: <1270761488.16012.11.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 15:26 -0400, Luis R. Rodriguez wrote:
> AR9003 does not have a reset control for AHB.
...
> +			val = AR_RC_HOSTIF;
> +			if (!AR_SREV_9300_20_OR_LATER(ah))
> +				val |= AR_RC_AHB;

Perhaps AR_RC_AHB could be defined to 0 for AR9300 in the header?  Just
an idea.

-- 
Regards,
Pavel Roskin
