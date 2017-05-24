Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030969AbdEXNkO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:40:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: rsi_91x_core: Use time_after time comparison
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1494282850-13782-1-git-send-email-karim.eshapa@gmail.com>
References: <1494282850-13782-1-git-send-email-karim.eshapa@gmail.com>
To: Karim Eshapa <karim.eshapa@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karim Eshapa <karim.eshapa@gmail.com>
Message-Id: <20170524134013.EBA4C61155@smtp.codeaurora.org> (sfid-20170524_154106_038196_02D82AA7)
Date: Wed, 24 May 2017 13:40:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karim Eshapa <karim.eshapa@gmail.com> wrote:
> Use time_after kernel macro for time comparison.
> 
> Signed-off-by: Karim Eshapa <karim.eshapa@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

c07036f18d93 rsi: rsi_91x_core: Use time_after time comparison

-- 
https://patchwork.kernel.org/patch/9716843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
