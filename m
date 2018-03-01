Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56484 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967191AbeCAKGp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:06:45 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/13] ath10k: platform driver for WCN3990 SNOC WLAN module
References: <1518684458-5338-1-git-send-email-govinds@codeaurora.org>
Date: Thu, 01 Mar 2018 12:06:41 +0200
In-Reply-To: <1518684458-5338-1-git-send-email-govinds@codeaurora.org> (Govind
        Singh's message of "Thu, 15 Feb 2018 14:17:38 +0530")
Message-ID: <87371kqfda.fsf@kamboji.qca.qualcomm.com> (sfid-20180301_110805_651207_A4A01DB2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> WCN3990 is integrated 802.11ac chipset with SNOC
> bus interface. Add snoc layer driver registration
> and associated ops.
>
> WCN3990 support is not yet complete as cold-boot
> handshake is done using qmi(Qualcomm-MSM-Interface)
> and qmi client support will be added once qmi framework
> is available.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>

Kbuild bot found an odd problem with this patch:

 include/linux/dynamic_debug.h:77:14: error: 'KBUILD_MODNAME'
 undeclared (first use in this function); did you mean
 'KBUILD_BASENAME'?

Full report:

http://lists.infradead.org/pipermail/ath10k/2018-February/010907.html

Any ideas? Is this is some unrelated issue or what? This patch is not
even touching hif.h or ce.c.

-- 
Kalle Valo
