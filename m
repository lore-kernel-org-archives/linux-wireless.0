Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63976 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYGRQot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 12:44:49 -0400
Subject: Re: [PATCH] ath5k: don't enable MSI, we cannot handle it yet
From: Pavel Roskin <proski@gnu.org>
To: stable@kernel.org
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mickflemm@gmail.com
In-Reply-To: <20080718162855.22182.97573.stgit@dv.roinet.com>
References: <20080718162855.22182.97573.stgit@dv.roinet.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 12:44:47 -0400
Message-Id: <1216399487.18320.16.camel@dv> (sfid-20080718_184452_421365_AE65BCC2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-07-18 at 12:28 -0400, Pavel Roskin wrote:
> This fixes support for AR5006 chipset, which supports MSI

Sorry, I found Documentation/stable_kernel_rules.txt minutes after
sending the patch.  We need to get it to the Linus' tree first, then to
the stable tree.  I hope it won't take long.

To preempt possible questions: MSI is a nice thing, but we cannot enable
it without changing the interrupt handler.  If we do it, we break MSI
capable hardware.

-- 
Regards,
Pavel Roskin
