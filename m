Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935350AbcKWPe0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 10:34:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00: Fix incorrect usage of CONFIG_RT2X00_LIB_USB
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479312114-9389-1-git-send-email-vishalthanki@gmail.com>
References: <1479312114-9389-1-git-send-email-vishalthanki@gmail.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        linux-wireless@vger.kernel.org,
        Vishal Thanki <vishalthanki@gmail.com>
Message-Id: <20161123153420.A2E6961556@smtp.codeaurora.org> (sfid-20161123_163435_817137_2F4B7E95)
Date: Wed, 23 Nov 2016 15:34:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vishal Thanki <vishalthanki@gmail.com> wrote:
> In device removal routine, usage of "#ifdef CONFIG_RT2X00_LIB_USB"
> will not cover the case when it is configured as module. This will
> omit the entire if-block which does cleanup of URBs and cancellation
> of pending work. Changing the #ifdef to #if IS_ENABLED() to fix it.
> 
> Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

a083c8fd277b rt2x00: Fix incorrect usage of CONFIG_RT2X00_LIB_USB

-- 
https://patchwork.kernel.org/patch/9431983/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
