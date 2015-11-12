Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43577 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbKLTtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:49:55 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 6/9] brcmfmac: Add RSDB support.
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
	<1446147199-21671-7-git-send-email-arend@broadcom.com>
Date: Thu, 12 Nov 2015 21:49:48 +0200
In-Reply-To: <1446147199-21671-7-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Thu, 29 Oct 2015 20:33:16 +0100")
Message-ID: <87io57576r.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_204957_930423_A2C0A558)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>
> RSDB works almost autonomously in firmware except for AP config.
> When device supports RSDB then the interface should not be
> brought down when configuring it, otherwise the link (if
> configured) on the other interface will be lost.
>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

I have never heard of acronym RSDB before and after some googling I
think it might mean Real Simultaneous Dual Band. But please try to avoid
using acronyms and clearly spell it out in the commit log what the
feature is about.

If you send me suggestions what to add I can edit the commit log before
I apply this patch.

-- 
Kalle Valo
