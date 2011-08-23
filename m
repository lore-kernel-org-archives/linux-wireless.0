Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56078 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587Ab1HWIoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:44:55 -0400
Received: by mail-bw0-f44.google.com with SMTP id r4so7100728bka.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 01:44:53 -0700 (PDT)
Subject: Re: [PATCH 3.1] wl12xx: add max_sched_scan_ssids value to the hw
 description
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314088945-19848-1-git-send-email-coelho@ti.com>
References: <1314088945-19848-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 11:44:50 +0300
Message-ID: <1314089090.2296.127.camel@cumari> (sfid-20110823_104458_168965_55BAA84C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2011-08-23 at 11:42 +0300, Luciano Coelho wrote: 
> After commit 5a865ba, we require a separate value to indicate the
> number of supported SSIDs in scheduled scans.  This patch adds a
> proper value to the wl12xx driver.
> 
> This fixes a regression in 3.1-rc3 where scheduled scans were not
> working properly with the wl12xx driver.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Could you please apply this patch to 3.1 too? For some reason I didn't
push my change in the wl12xx driver after I made the changes to include
max_sched_scan_ssids in the hw configuration.

This is a one-liner very trivial patch that fixes a regression, so I
hope it's still okay to get it in.

-- 
Cheers,
Luca.

