Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbcKIBIK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 20:08:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [3/3] rsi: Updated boot parameters
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1476358025-15576-1-git-send-email-prameela.j04cs@gmail.com>
References: <1476358025-15576-1-git-send-email-prameela.j04cs@gmail.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20161109010810.090106135D@smtp.codeaurora.org> (sfid-20161109_020814_070432_1BB56060)
Date: Wed,  9 Nov 2016 01:08:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> wrote:
> * Switch clock info is divided in to different clock information fields for
>   readability and synchronization with firmware code.
> * Other parameters are added for future use and to make the frame size in sync
>   with latest firmware. Otherwise firmware will discard the frame considering
>   corrupted frame.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

This looks broken and no reply to my comment.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9374883/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
