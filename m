Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbeCLJqG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 05:46:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RESEND] rsi: Remove stack VLA usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1520819022-15238-1-git-send-email-me@tobin.cc>
References: <1520819022-15238-1-git-send-email-me@tobin.cc>
To: tcharding <me@tobin.cc>
Cc: "Tobin C. Harding" <me@tobin.cc>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>
Message-Id: <20180312094606.7197F607F5@smtp.codeaurora.org> (sfid-20180312_104704_643568_E1C2C4E8)
Date: Mon, 12 Mar 2018 09:46:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tcharding <me@tobin.cc> wrote:

> The kernel would like to have all stack VLA usage removed[1].  rsi uses
> a VLA based on 'blksize'.  Elsewhere in the SDIO code maximum block size
> is defined using a magic number.  We can use a pre-processor defined
> constant and declare the array to maximum size.  We add a check before
> accessing the array in case of programmer error.
> 
> [1]: https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Tobin, your name in patchwork.kernel.org is just "tcharding" then it should be
"Tobin C. Harding". Patchwork is braindead in a way as it takes the name from
it's database instead of the From header of the patch in question.

I can fix that manually but it would be helpful if you could register to
patchwork and fix your name during registration. You have only one chance to
fix your name (another braindead feature!) so be careful :)

-- 
https://patchwork.kernel.org/patch/10274983/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
