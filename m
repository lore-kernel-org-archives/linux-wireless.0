Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32564 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723Ab0DGQkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 12:40:15 -0400
Subject: Re: [PATCH] ath9k: fix compilation without CONFIG_ATH9K_DEBUGFS
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4BBCB44F.7050805@openwrt.org>
References: <20100407052611.23065.48030.stgit@mj.roinet.com>
	 <4BBCB44F.7050805@openwrt.org>
Content-Type: text/plain
Date: Wed, 07 Apr 2010 12:40:14 -0400
Message-Id: <1270658414.12126.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-07 at 09:35 -0700, Felix Fietkau wrote:
> On 2010-04-06 10:26 PM, Pavel Roskin wrote:
> > Make arguments of ath_debug_stat_tx() and ath_debug_stat_rx() stubs
> > match those of the same functions with CONFIG_ATH9K_DEBUGFS defined.
> > 
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> Isn't that the same as what I already sent on March 31st?

That's it exactly.  Sorry, I missed it.

John, please commit it soon.  It's a compile issue.

-- 
Regards,
Pavel Roskin
