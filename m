Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2Hj5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:39:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Revert "rt2800: use TXOP_BACKOFF for probe frames"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527506706-6488-1-git-send-email-sgruszka@redhat.com>
References: <1527506706-6488-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180529073956.F103160591@smtp.codeaurora.org> (sfid-20180529_094001_043021_B170002D)
Date: Tue, 29 May 2018 07:39:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> This reverts commit fb47ada8dc3c30c8e7b415da155742b49536c61e.
> 
> In some situations when we set TXOP_BACKOFF, the probe frame is
> not sent at all. What it worse then sending probe frame as part
> of AMPDU and can degrade 11n performance to 11g rates.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

52a192362932 Revert "rt2800: use TXOP_BACKOFF for probe frames"

-- 
https://patchwork.kernel.org/patch/10431861/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
