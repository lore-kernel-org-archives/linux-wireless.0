Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:45439 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757837Ab1F0LJB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 07:09:01 -0400
Received: by bwd5 with SMTP id 5so1611995bwd.5
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 04:08:59 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: use freezable workqueue for netstack_work
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1307440246-22062-1-git-send-email-eliad@wizery.com>
References: <1307440246-22062-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:08:56 +0300
Message-ID: <1309172936.30221.30.camel@cumari> (sfid-20110627_131559_919591_B905FA91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-07 at 12:50 +0300, Eliad Peller wrote: 
> When resuming (after wowlan), we want the rx packets (which is
> usually the wake-up packet itself) to be passed to mac80211 only
> after the resume notifier was completed, and mac80211 is up and
> running (otherwise, the packets will be dropped).
> 
> By enqueueing the netstack_work to a freezable workqueue, we can
> guarantee the rx processing to occur only after mac80211 was resumed.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Applied.  Thanks!

-- 
Cheers,
Luca.

