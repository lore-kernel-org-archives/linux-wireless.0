Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47146 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdHJI6Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 04:58:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,06/20] brcm80211: constify usb_device_id
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502295926-21042-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502295926-21042-1-git-send-email-arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: petkan@nucleusys.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, wright.feng@cypress.com,
        hante.meuleman@broadcom.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Message-Id: <20170810085823.8B48E601D8@smtp.codeaurora.org> (sfid-20170810_105840_620936_70D2728E)
Date: Thu, 10 Aug 2017 08:58:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> usb_device_id are not supposed to change at runtime. All functions
> working with usb_device_id provided by <linux/usb.h> work with
> const usb_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Does not apply to wireless-drivers-next:

error: Failed to merge in the changes.
Applying: brcm80211: constify usb_device_id
Using index info to reconstruct a base tree...
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
Patch failed at 0001 brcm80211: constify usb_device_id
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9890985/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
