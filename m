Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeA2OpE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 09:45:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,2/2] ath10k: Add support for Ubiquiti rebranded QCA988X v2
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180125111340.17553-3-tobleminer@gmail.com>
References: <20180125111340.17553-3-tobleminer@gmail.com>
To: Tobias Schramm <tobleminer@gmail.com>
Cc: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org, Tobias Schramm <tobleminer@gmail.com>
Message-Id: <20180129144503.6A5B4609EF@smtp.codeaurora.org> (sfid-20180129_154509_322329_8AB4D9CA)
Date: Mon, 29 Jan 2018 14:45:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Schramm <tobleminer@gmail.com> wrote:

> Some modern Ubiquiti devices contain a rebranded QCA988X rev2 with
> a custom Ubiquiti vendor and device id. This patch adds support for
> those devices, treating them as a QCA988X v2.
> 
> Signed-off-by: Tobias Schramm <tobleminer@gmail.com>
> [kvalo@codeaurora.org: rebase, add missing fields in hw_params, fix a long line in pci.c:61]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This didn't apply to ath.git so I rebased it and it did some other modifications
(list in the commit log):

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=4037b395c946f94ee05ddc652421cdbd35567a3e

-- 
https://patchwork.kernel.org/patch/10183909/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
