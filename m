Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57260 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdG1PEC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:04:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [11/11] brcmfmac: constify pci_device_id
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1500315402-3439-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500315402-3439-1-git-send-email-arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: arend.vanspriel@broadcom.com, hante.meuleman@broadcom.com,
        franky.lin@broadcom.com, wright.feng@cypress.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Message-Id: <20170728150401.C25B360A18@smtp.codeaurora.org> (sfid-20170728_170416_601756_2C4A4BE7)
Date: Fri, 28 Jul 2017 15:04:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

e66d70b789d1 brcmfmac: constify pci_device_id

-- 
https://patchwork.kernel.org/patch/9845919/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
