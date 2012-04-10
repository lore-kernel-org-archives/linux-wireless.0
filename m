Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:60032 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753566Ab2DJKOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 06:14:06 -0400
Received: by lbao2 with SMTP id o2so2772198lba.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 03:14:02 -0700 (PDT)
Message-ID: <1334052835.10268.0.camel@cumari> (sfid-20120410_121409_954110_73E154CE)
Subject: Re: [PATCH] wl12xx: set do_join on BSS_CHANGED_ASSOC
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 13:13:55 +0300
In-Reply-To: <1331556784-25291-1-git-send-email-eliad@wizery.com>
References: <1331556784-25291-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-12 at 14:53 +0200, Eliad Peller wrote: 
> wl12xx sets the do_join flag (which later starts the
> sta role) when the bssid was changed and the sta is
> associated. However, this no longer happens after
> the "mac80211: remove spurious BSSID change flag"
> patch.
> 
> Fix it by setting the do_join flag on BSS_CHANGED_ASSOC
> (for IBSS, do_join is already set on BSS_CHANGED_IBSS)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied and pushed to wl12xx/master.  Thanks!

-- 
Cheers,
Luca.

