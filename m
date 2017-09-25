Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932617AbdIYIV6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:21:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] brcmfmac: use setup_timer() helper
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com>
References: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com>
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
Message-Id: <20170925082157.9B9C760B72@smtp.codeaurora.org> (sfid-20170925_104608_257734_83C2070C)
Date: Mon, 25 Sep 2017 08:21:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allen Pais <allen.lkml@gmail.com> wrote:

> Use setup_timer function instead of initializing timer with the
> function and data fields.
> 
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

30ac40763939 brcmfmac: use setup_timer() helper

-- 
https://patchwork.kernel.org/patch/9963851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
