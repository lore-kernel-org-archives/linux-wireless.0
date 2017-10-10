Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755533AbdJJI0D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 04:26:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: net/wireless/ray_cs: Convert timers to use
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171005005020.GA23219@beast>
References: <20171005005020.GA23219@beast>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Message-Id: <20171010082603.6B3EA60723@smtp.codeaurora.org> (sfid-20171010_102625_489810_B8B9D945)
Date: Tue, 10 Oct 2017 08:26:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:

> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>

I'll apply this once I have fast forwarded wireless-drivers-next to
-rc3. I'll also fix the title, what was it supposed to say?

Patch set to Awaiting Upstream.

-- 
https://patchwork.kernel.org/patch/9986253/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
