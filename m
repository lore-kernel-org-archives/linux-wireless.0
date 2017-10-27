Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:20681 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdJ0NzV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:55:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: drivers/wireless: ath: Convert timers to use timer_setup()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171024092954.GA47365@beast>
References: <20171024092954.GA47365@beast>
To: Kees Cook <keescook@chromium.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <7f6d49062e354d07a23971bd4388c513@euamsexm01a.eu.qualcomm.com> (sfid-20171027_155541_385549_673A810A)
Date: Fri, 27 Oct 2017 15:55:14 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:

> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

7ac767645ab1 ath: Convert timers to use timer_setup()

-- 
https://patchwork.kernel.org/patch/10023835/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
