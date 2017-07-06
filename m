Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26242 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdGFMSJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 08:18:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: Make CE layer bus agnostic
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1498625306-21900-1-git-send-email-govinds@qti.qualcomm.com>
References: <1498625306-21900-1-git-send-email-govinds@qti.qualcomm.com>
To: Govind Singh <govinds@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Govind Singh <govinds@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <63060d6b10074d43ac9877099a61e6a2@eusanexr01a.eu.qualcomm.com> (sfid-20170706_141812_803376_CFB95335)
Date: Thu, 6 Jul 2017 05:18:05 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@qti.qualcomm.com> wrote:

> Remove bus specific dependencies from CE layer
> to have common CE layer across multiple targets.
> This is required for adding support for WCN3990
> chipset support as WCN3990 chipset uses SNOC
> bus interface with Copy Engine endpoint.
> 
> Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

641fe28ad305 ath10k: make CE layer bus agnostic
f9e18304544e ath10k: add copy engine register MAP for wcn3990 target

-- 
https://patchwork.kernel.org/patch/9813463/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
