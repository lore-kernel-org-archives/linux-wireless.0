Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17137 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0G3TdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 15:33:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jul 2010 12:33:24 -0700
Date: Fri, 30 Jul 2010 12:33:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 4/4] ath9k_hw: fix analog shift register writes on
 AR9003
Message-ID: <20100730193321.GC2132@tux>
References: <1280516532-42721-1-git-send-email-nbd@openwrt.org>
 <1280516532-42721-2-git-send-email-nbd@openwrt.org>
 <1280516532-42721-3-git-send-email-nbd@openwrt.org>
 <1280516532-42721-4-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1280516532-42721-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 30, 2010 at 12:02:12PM -0700, Felix Fietkau wrote:
> Writes to the analog shift registers, which are issues by the initval
> programming function, require a 100 usec delay (similar to AR9002,
> but in a different register range).
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

For all 4

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
