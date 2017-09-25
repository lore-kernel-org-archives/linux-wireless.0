Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932117AbdIYHpJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 03:45:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] wireless: broadcom: brcm80211: use setup_timer() helper
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com>
References: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com>
To: Allen <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
Message-Id: <20170925074509.3E2626044E@smtp.codeaurora.org> (sfid-20170925_100027_676818_3507D3C5)
Date: Mon, 25 Sep 2017 07:45:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allen <allen.lkml@gmail.com> wrote:

> Use setup_timer function instead of initializing timer with the
>     function and data fields.
> 
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Also your name in patchwork is just "Allen", without your lastname. I can fix
it this time, but please register to patchwork to fix your name. (Annoyingly
patchwork takes the name from it's database, not from the "From:" header)

-- 
https://patchwork.kernel.org/patch/9963851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
