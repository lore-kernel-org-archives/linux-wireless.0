Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdJ0Hrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 03:47:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: drivers/wireless: rsi: Convert timers to use timer_setup()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171024092909.GA47160@beast>
References: <20171024092909.GA47160@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171027074734.6F50260314@smtp.codeaurora.org> (sfid-20171027_094758_835977_86FDF19A)
Date: Fri, 27 Oct 2017 07:47:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:

> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Cc: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
> Cc: Karun Eagalapati <karun256@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

dfefb9f8d082 drivers/wireless: rsi: Convert timers to use timer_setup()

-- 
https://patchwork.kernel.org/patch/10023815/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
