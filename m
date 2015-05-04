Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41787 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbEDSIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 14:08:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 0/7] wil6210 patches
In-Reply-To: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Wed, 29 Apr 2015 14:44:59 +0300")
References: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Mon, 04 May 2015 21:08:03 +0300
Message-ID: <87sibcusfw.fsf@kamboji.qca.qualcomm.com> (sfid-20150504_200814_957939_DF25953D)
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

Thanks, applied to ath.git. I'll start applying wil6210 patches to
ath.git from now on.

-- 
Kalle Valo
