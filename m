Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3679 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYE3P6n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 11:58:43 -0400
Date: Fri, 30 May 2008 11:41:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH, take 2] libertas: unify various CF-related defines
Message-ID: <20080530154113.GB9490@tuxdriver.com> (sfid-20080530_175847_420388_A789B42C)
References: <200805261250.50363.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805261250.50363.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2008 at 12:50:50PM +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

git says:

Applying libertas: don't spin_unlock_irq() twice
Applying libertas: speeds up downloading of CF firmware
Applying libertas: use lbs_pr_XX instead of printk
Applying libertas: before sleeping, check for a command result
Applying libertas: unify various CF-related defines
error: patch failed: drivers/net/wireless/libertas/if_cs.c:221
error: drivers/net/wireless/libertas/if_cs.c: patch does not apply

patch says:

/home/linville/git/wireless-testing
[linville-t43.local]:> patch -p1 < tmp.mbox
patching file drivers/net/wireless/libertas/if_cs.c
Hunk #2 succeeded at 360 with fuzz 1 (offset 155 lines).
Hunk #3 FAILED at 383.
Hunk #4 FAILED at 393.
Hunk #5 FAILED at 426.
Hunk #6 FAILED at 450.
Hunk #7 FAILED at 496.
Hunk #8 FAILED at 511.
Hunk #9 FAILED at 533.
Hunk #10 FAILED at 546.
Hunk #11 FAILED at 557.
Hunk #12 FAILED at 580.
Hunk #13 succeeded at 344 (offset -152 lines).
Hunk #14 succeeded at 712 (offset 155 lines).
Hunk #15 succeeded at 431 (offset -152 lines).
Hunk #16 succeeded at 975 (offset 155 lines).
10 out of 16 hunks FAILED -- saving rejects to file drivers/net/wireless/libertas/if_cs.c.rej

It looks like a lot of fiddly changes that I (and probably everyone
else) would rather get fixed-up by someone closer to the driver.

John
-- 
John W. Linville
linville@tuxdriver.com
