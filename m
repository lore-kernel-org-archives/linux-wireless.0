Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56936 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751855AbeEDMff (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 08:35:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rt2x00: call sta_add/remove directly in rt2800
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525094357-24782-1-git-send-email-sgruszka@redhat.com>
References: <1525094357-24782-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20180504123534.D7048607E4@smtp.codeaurora.org> (sfid-20180504_143540_149820_CE7A7D6D)
Date: Fri,  4 May 2018 12:35:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Only rt2800 subdriver of rt2x00 implement sta_add() and sta_remove(),
> we do not need generic version of those.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

2 patches applied to wireless-drivers-next.git, thanks.

9c87758cf089 rt2x00: call sta_add/remove directly in rt2800
811a39915107 rt2x00: check against flushing empty queue

-- 
https://patchwork.kernel.org/patch/10371779/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
