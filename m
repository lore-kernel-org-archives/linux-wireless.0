Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52260 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbbEVKdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 06:33:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v2] wil6210: fix format specifier for dma_addr_t
References: <1431360648-4854-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Fri, 22 May 2015 13:33:12 +0300
In-Reply-To: <1431360648-4854-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Mon, 11 May 2015 19:10:48 +0300")
Message-ID: <87lhgg6gwn.fsf@kamboji.qca.qualcomm.com> (sfid-20150522_123325_868489_59F20028)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Fix format specifier used for dma_addr_t, namely use %pad
> Debug print virtual address for the same buffer as well.
>
> It can be applied as:
> fixup! wil6210: Add pmc debug mechanism memory management
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, applied. I just added a proper fixes line:

commit 80714b09bc574c5b23e50264e76e6e0f78d23549
Author: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Date:   Mon May 11 19:10:48 2015 +0300

    wil6210: fix format specifier for dma_addr_t
    
    Fix format specifier used for dma_addr_t, namely use %pad
    Debug print virtual address for the same buffer as well.
    
    Fixes: dc16427bbe65 ("wil6210: Add pmc debug mechanism memory management")
    Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
