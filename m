Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52713 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbYGRQuA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 12:50:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] ath5k: don't enable MSI, we cannot handle it yet
Date: Fri, 18 Jul 2008 18:49:24 +0200
Cc: stable@kernel.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mickflemm@gmail.com
References: <20080718162855.22182.97573.stgit@dv.roinet.com> <1216399487.18320.16.camel@dv>
In-Reply-To: <1216399487.18320.16.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807181849.25320.mb@bu3sch.de> (sfid-20080718_185005_980068_87E6D6D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 18 July 2008 18:44:47 Pavel Roskin wrote:
> On Fri, 2008-07-18 at 12:28 -0400, Pavel Roskin wrote:
> > This fixes support for AR5006 chipset, which supports MSI
> 
> Sorry, I found Documentation/stable_kernel_rules.txt minutes after
> sending the patch.  We need to get it to the Linus' tree first, then to
> the stable tree.  I hope it won't take long.
> 
> To preempt possible questions: MSI is a nice thing, but we cannot enable
> it without changing the interrupt handler.  If we do it, we break MSI
> capable hardware.

Please include this into the patch changelog. It's highly confusing otherwise ;)

-- 
Greetings Michael.
