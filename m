Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdJ0HpI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 03:45:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlegacy: Convert timers to use timer_setup()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171024092845.GA47078@beast>
References: <20171024092845.GA47078@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171027074507.99FF060542@smtp.codeaurora.org> (sfid-20171027_094546_346445_D366C081)
Date: Fri, 27 Oct 2017 07:45:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:

> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

2b77839b3734 iwlegacy: Convert timers to use timer_setup()

-- 
https://patchwork.kernel.org/patch/10023849/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
