Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbeAPOa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:30:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: add a quirk to set use_msi automatically
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515461962-27129-1-git-send-email-acelan.kao@canonical.com>
References: <1515461962-27129-1-git-send-email-acelan.kao@canonical.com>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180116143057.2F8DC6076A@smtp.codeaurora.org> (sfid-20180116_153135_284981_8DBDA16E)
Date: Tue, 16 Jan 2018 14:30:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AceLan Kao <acelan.kao@canonical.com> wrote:

> Some platform(BIOS) blocks legacy interrupts (INTx), and only allows MSI
> for WLAN device. So adding a quirk to list those machines and set
> use_msi automatically.
> Adding the following platforms to the quirk.
>    Dell Inspiron 24-3460
>    Dell Inspiron 3472
>    Dell Inspiron 14-3473
>    Dell Vostro 3262
>    Dell Vostro 15-3572
> 
> Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3153b68e4d1a ath9k: add a quirk to set use_msi automatically

-- 
https://patchwork.kernel.org/patch/10150851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
