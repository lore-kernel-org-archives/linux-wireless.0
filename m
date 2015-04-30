Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53432 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbD3Cr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 22:47:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 0/7] wil6210 patches
References: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Thu, 30 Apr 2015 05:47:49 +0300
In-Reply-To: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Wed, 29 Apr 2015 14:44:59 +0300")
Message-ID: <87y4la1gdm.fsf@kamboji.qca.qualcomm.com> (sfid-20150430_044813_568922_21BF169F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> - introduced debug trace facility (PMC) that extracts events
>   reported by the hardware
> - introduced real broadcast for secure link
> - other are small fixes here and there
>
> Vladimir Kondratiev (7):
>   wil6210: increase timeout for the "echo" command
>   wil6210: update Rx descriptor fields
>   wil6210: fix boot loader "ready" indication
>   wil6210: fix for probe_resp IE's
>   wil6210: Add pmc debug mechanism memory management
>   wil6210: broadcast for secure link
>   wil6210: support WSC for STA mode

I see some warnings and errors:

drivers/net/wireless/ath/wil6210/pmc.c:94:228: warning: format '%ld' expects argument of type 'long int', but argument 6 has type 'unsigned int' [-Wformat]
drivers/net/wireless/ath/wil6210/pmc.c:94:228: warning: format '%ld' expects argument of type 'long int', but argument 8 has type 'unsigned int' [-Wformat]
drivers/net/wireless/ath/wil6210/pmc.c:94:448: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat]
drivers/net/wireless/ath/wil6210/pmc.c:94:448: warning: format '%ld' expects argument of type 'long int', but argument 7 has type 'unsigned int' [-Wformat]

[...]

Kernel: arch/x86/boot/bzImage is ready  (#923)
  Building modules, stage 2.
  MODPOST 45 modules
ERROR: "__divdi3" [drivers/net/wireless/ath/wil6210/wil6210.ko] undefined!

-- 
Kalle Valo
