Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40676 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbJNLUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:20:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eric Caruso <ejcaruso@google.com>
Cc: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, linux-wireless@vger.kernel.org,
	leizh@broadcom.com
Subject: Re: [PATCH] brcm80211: Add support for brcm4371
References: <1444329646-11495-1-git-send-email-ejcaruso@google.com>
Date: Wed, 14 Oct 2015 14:20:12 +0300
In-Reply-To: <1444329646-11495-1-git-send-email-ejcaruso@google.com> (Eric
	Caruso's message of "Thu, 8 Oct 2015 11:40:46 -0700")
Message-ID: <87d1whn1cj.fsf@kamboji.qca.qualcomm.com> (sfid-20151014_132022_546340_9E23B5EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Caruso <ejcaruso@google.com> writes:

> This is a new Broadcom chip and we should be able to recognize it.
>
> Signed-off-by: Eric Caruso <ejcaruso@google.com>

This didn't apply. Please rebase on top of wireless-drivers-next and
resend.

Applying: brcm80211: Add support for brcm4371
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
CONFLICT (content): Merge conflict in
drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
Auto-merging drivers/net/wireless/brcm80211/brcmfmac/pcie.c
CONFLICT (content): Merge conflict in
drivers/net/wireless/brcm80211/brcmfmac/pcie.c
Auto-merging drivers/net/wireless/brcm80211/brcmfmac/chip.c
Failed to merge in the changes.
Patch failed at 0001 brcm80211: Add support for brcm4371

-- 
Kalle Valo
