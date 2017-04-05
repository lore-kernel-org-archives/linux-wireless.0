Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755099AbdDEMjq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 08:39:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: enable auto deep sleep mode for USB chipsets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1490620012-2733-1-git-send-email-akarwar@marvell.com>
References: <1490620012-2733-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170405123946.3BDAA60CA2@smtp.codeaurora.org> (sfid-20170405_144108_079000_3B413A62)
Date: Wed,  5 Apr 2017 12:39:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> Chip goes into low power state when this feature is enabled.
> This was already enabled for SDIO and PCIe interface based
> chipsets.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

36491b152c30 mwifiex: enable auto deep sleep mode for USB chipsets

-- 
https://patchwork.kernel.org/patch/9646617/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
