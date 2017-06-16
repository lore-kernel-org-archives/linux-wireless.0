Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48693 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbdFPG56 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 02:57:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: Define structures for CE ctrl/misc register
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1496739941-18132-1-git-send-email-c_sgarna@qti.qualcomm.com>
References: <1496739941-18132-1-git-send-email-c_sgarna@qti.qualcomm.com>
To: Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <5db1646de68e4b9c86763c7a37ba1397@euamsexm01a.eu.qualcomm.com> (sfid-20170616_085825_375849_33F6AA0C)
Date: Fri, 16 Jun 2017 08:51:49 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com> wrote:

> Define structures for the copy engine ctrl/misc registers,
> that includes CE CMD halt, watermark source, watermark destination,
> host IE ring, source, destination and dmax ring.
> 
> This adds support to avoid the conditional compilation,
> code optimization and dynamic configuration of the copy engine
> register map for respective hardware bus interface.
> 
> Signed-off-by: Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

03a016f8944c ath10k: define structures for CE ctrl/misc register

-- 
https://patchwork.kernel.org/patch/9768317/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
