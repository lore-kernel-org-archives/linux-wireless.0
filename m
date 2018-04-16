Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755153AbeDPN64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:58:56 -0400
Received: from mail-qt0-f175.google.com (mail-qt0-f175.google.com [209.85.216.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5DF217DF
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 13:58:55 +0000 (UTC)
Received: by mail-qt0-f175.google.com with SMTP id l8so11539151qtp.6
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 06:58:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523269296-29900-1-git-send-email-merez@codeaurora.org>
References: <1523269296-29900-1-git-send-email-merez@codeaurora.org>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 16 Apr 2018 09:58:54 -0400
Message-ID: <CA+5PVA7E4r7Dx2kKe15trmS=7iuNvbjcF8LutfmTw10gLVMn-A@mail.gmail.com> (sfid-20180416_155858_869525_91D10CC8)
Subject: Re: [PATCH] linux-firmware: update wil6210 firmware to 5.2.0.18
To: Maya Erez <merez@codeaurora.org>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        wil6210@qti.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 9, 2018 at 6:21 AM, Maya Erez <merez@codeaurora.org> wrote:
> This is the latest firmware from wil6210 5.2 firmware branch.
>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> ---
>  WHENCE      |   2 +-
>  wil6210.brd | Bin 3588 -> 3588 bytes
>  wil6210.fw  | Bin 350748 -> 400364 bytes
>  3 files changed, 1 insertion(+), 1 deletion(-)

Applied and pushed out.  Thanks.

josh
