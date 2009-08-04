Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3964 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZHDMWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 08:22:51 -0400
Date: Tue, 4 Aug 2009 08:22:29 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: make irq handling interface specific
Message-ID: <20090804122229.GA3337@hash.localnet>
References: <20090804033908.GA1903@hash.localnet> <87hbwoniog.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87hbwoniog.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 04, 2009 at 10:26:39AM +0300, Kalle Valo wrote:
> So this patch is only needed on top of the rebased sdio patchset I sent
> few weeks ago to get sdio working? Or did I miss any patches? I'm just
> being careful here because I want to get sdio support to 2.6.32 (if it's
> ok for John) and there isn't that much time for that.

Hi Kalle,

Yes, the only other patch I have is for the platform gpios for the MSM
kernel (msm_wifi.ko module for HTC Dream) which doesn't touch this at all
and is platform specific.  The plan was to turn that into a platform
rfkill driver, though it can probably go to staging in its present form
with the other Dream stuff.

-- 
Bob Copeland %% www.bobcopeland.com

