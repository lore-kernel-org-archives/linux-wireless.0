Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732570AbeHIReb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:34:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH wireless-drivers] mt76x0: Remove VLA usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180807225040.GA2164@beast>
References: <20180807225040.GA2164@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180809150911.7D1F660AD8@smtp.codeaurora.org> (sfid-20180809_170922_579536_06352F1D)
Date: Thu,  9 Aug 2018 15:09:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:

> Even with "const" variables, the compiler will generate warnings about
> VLA usage. In the quest to remove all VLAs from the kernel[1], this uses
> a #define instead of a const to do the array sizing.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Fixes: e87b5039511a ("mt76x0: eeprom files")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

17ad18fd12a3 mt76x0: Remove VLA usage

-- 
https://patchwork.kernel.org/patch/10559297/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
