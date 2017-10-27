Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56191 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdJ0JTE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 05:19:04 -0400
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
Message-ID: <df4525f9d784450fabe4bf685af6992e@euamsexm01a.eu.qualcomm.com> (sfid-20171027_111908_997992_C31B2F59)
Date: Fri, 27 Oct 2017 11:18:56 +0200
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

There were some conflicts but luckily 3-way merge was able to automatically
solve them. But please do check the patch from my pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=master-pending&id=dd08329d31a4c150f8aab8274033901baaf3e923

-- 
https://patchwork.kernel.org/patch/10023835/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
