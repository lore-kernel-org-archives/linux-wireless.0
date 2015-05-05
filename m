Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49016 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965472AbbEEFdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 01:33:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v3 0/7] wil6210 patches
References: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Tue, 05 May 2015 08:33:48 +0300
In-Reply-To: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Tue, 5 May 2015 01:11:49 +0300")
Message-ID: <87fv7bvb9f.fsf@kamboji.qca.qualcomm.com> (sfid-20150505_073437_284103_CD9931ED)
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
> v2:
>
> fix patch "wil6210: Add pmc debug mechanism memory management"
> for 32-bit platforms
>
> v3:
>
> fix patch "wil6210: Add pmc debug mechanism memory management"
> for pointers and dma_addr_t printing
>
> Vladimir Kondratiev (7):
>   wil6210: increase timeout for the "echo" command
>   wil6210: update Rx descriptor fields
>   wil6210: fix boot loader "ready" indication
>   wil6210: fix for probe_resp IE's
>   wil6210: Add pmc debug mechanism memory management
>   wil6210: broadcast for secure link
>   wil6210: support WSC for STA mode

I applied the v2 patchset just few hours before you sent these so I
cannot apply these anymore. Please send a new patch on top of v2.

-- 
Kalle Valo
