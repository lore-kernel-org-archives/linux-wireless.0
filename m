Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56442 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbcCCPMr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:12:47 -0500
Message-ID: <1457017963.2044.19.camel@sipsolutions.net> (sfid-20160303_161250_675577_086AC0B4)
Subject: Re: [PATCH] mac80211: fix AP buffered multicast frames with queue
 control and txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Thu, 03 Mar 2016 16:12:43 +0100
In-Reply-To: <1456669193-56860-1-git-send-email-nbd@openwrt.org>
References: <1456669193-56860-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-02-28 at 15:19 +0100, Felix Fietkau wrote:
> Buffered multicast frames must be passed to the driver directly via
> drv_tx instead of going through the txq, otherwise they cannot easily
> be scheduled to be sent after DTIM.
> 
Applied.

johannes
