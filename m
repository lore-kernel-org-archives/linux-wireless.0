Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:58714 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab1DTRgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 13:36:13 -0400
Received: by mail-ey0-f179.google.com with SMTP id 5so304659eyg.38
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 10:36:11 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: sleep instead of wakeup after tx work
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301902727-25511-1-git-send-email-eliad@wizery.com>
References: <1301902727-25511-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 20:38:39 +0300
Message-ID: <1303321119.1988.735.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 10:38 +0300, Eliad Peller wrote:
> commit d05c806 ("wl12xx: rearrange some ELP wake_up/sleep calls")
> introduced a bug in which wl1271_ps_elp_wakeup() was called instead
> of wl1271_ps_elp_sleep() after completing the tx work.
> 
> Reported-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

