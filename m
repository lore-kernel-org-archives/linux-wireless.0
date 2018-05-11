Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39004 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752394AbeEKKSA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 06:18:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ssb: Fix regression caused by disabling PCI cores on non-MIPS
 architecture
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
References: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Message-Id: <20180511101800.71CD56081B@smtp.codeaurora.org> (sfid-20180511_121803_876545_1962AC00)
Date: Fri, 11 May 2018 10:18:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Some MPIS-based SoCs use chips driven by b43 for wireless capability.
> When ssb is configured as a module, build errors happen on these
> platforms as described in the commit 882164a4a928 ("ssb: Prevent build
> of PCI host features in module"). Unfortunately that change leads to
> the removal of code needed for correct operation on platforms that use
> PCI cores on the chip bus. The fix allows ssb to be build as a module
> for all architectures other than MIPS. This approach is ad-hoc, but it
> is the same as done in commit a9e6d44ddecc ("ssb: Do not disable PCI
> host on non-Mips").
> 
> This problem was reported and discussed in
> https://bugzilla.redhat.com/show_bug.cgi?id=1572349.
> 
> Fixes: commit 882164a4a928 ("ssb: Prevent build of PCI host features in module")
> Tested-by: Matt Redfearn <matt.redfearn@mips.com>
> Tested-by: Bruno Wolff III <bruno@wolff.to>
> Cc: Michael Büsch <m@bues.ch>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Dropped per Larry's request (on the other thread).

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/10390053/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
