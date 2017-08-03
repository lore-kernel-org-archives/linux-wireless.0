Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdHCKKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:10:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [10/11] net: qtnfmac: constify pci_device_id.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1500315263-3373-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500315263-3373-1-git-send-email-arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Message-Id: <20170803101031.6BEBA607B6@smtp.codeaurora.org> (sfid-20170803_121055_166320_291DECCA)
Date: Thu,  3 Aug 2017 10:10:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

cc5becd38e87 net: qtnfmac: constify pci_device_id.

-- 
https://patchwork.kernel.org/patch/9845911/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
