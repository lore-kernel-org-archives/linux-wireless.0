Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:44892 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab1HYHSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 03:18:49 -0400
Received: by mail-bw0-f45.google.com with SMTP id zv3so2044458bkb.18
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 00:18:48 -0700 (PDT)
Subject: Re: [PATCH v3] wl12xx: use 2 spare TX blocks for GEM cipher
From: Luciano Coelho <coelho@ti.com>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1313513352-32316-1-git-send-email-guy@wizery.com>
References: <1313513352-32316-1-git-send-email-guy@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 10:18:44 +0300
Message-ID: <1314256724.2296.246.camel@cumari> (sfid-20110825_091859_235789_B94BD33E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-16 at 19:49 +0300, Guy Eilam wrote: 
> Add tx_spare_blocks member to the wl1271 struct
> for more generic configuration of the amount
> of spare TX blocks that should be used.
> The default value is 1.
> In case GEM cipher is used by the STA, we need
> 2 spare TX blocks instead of just 1.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

