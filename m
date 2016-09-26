Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52702 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966402AbcIZRmF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 13:42:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] rtl8xxxu: Fix off by one error calculating pubq
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1474420769-20086-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1474420769-20086-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160926174205.284A16159A@smtp.codeaurora.org> (sfid-20160926_194210_480869_1E362445)
Date: Mon, 26 Sep 2016 17:42:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This was detected tracing the 8188eu driver, but doesn't seem to make
> any difference when using it.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

4 patches applied to wireless-drivers-next.git, thanks.

3a589fae4a2c rtl8xxxu: Fix off by one error calculating pubq
c0a99bbb1b7a rtl8xxxu: Clean up llt_init() API
2fc5dd27bf9b rtl8xxxu: Use a struct rtl8xxxu_fileops * in rtl8xxxu_init_device()
b42fbed6b8a5 rtl8xxxu: Stop log spam from each successful interrupt

-- 
https://patchwork.kernel.org/patch/9342651/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
