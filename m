Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E054C433B4
	for <linux-wireless@archiver.kernel.org>; Wed, 19 May 2021 12:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4A660FE8
	for <linux-wireless@archiver.kernel.org>; Wed, 19 May 2021 12:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbhESMnI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 May 2021 08:43:08 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33806 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239251AbhESMnI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 May 2021 08:43:08 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 8815D24718;
        Wed, 19 May 2021 05:41:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 8815D24718
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1621428108;
        bh=Pp5sVN3z7TafUlzwcbTe1his5AB3BD4IhdDQ2rcg+q8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Nci6TU1yLuRaYfQsFK8ELZlBsOzYz6VdJgnSl+41bE2xdB7mrOR6+nksj2nZQPV2U
         31wVGDT5Lbep6GMG06BAZaKNAHtmkrwnfSSmT5MloMCFfEXI+/dR2vYA3otSS8wemR
         XpvBIEvQCfgeeRQanenMKt4BKYrS1F6qG2gKoT7Y=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 4403C1874BE;
        Wed, 19 May 2021 05:41:45 -0700 (PDT)
Subject: Re: [PATCH 04/11] net: broadcom: brcmfmac: Demote non-compliant
 kernel-doc headers
To:     Yang Shen <shenyang39@huawei.com>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <20210517050141.61488-1-shenyang39@huawei.com>
 <20210517050141.61488-5-shenyang39@huawei.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c37eb46b-1ac8-4d04-187d-9ec870f707d8@broadcom.com>
Date:   Wed, 19 May 2021 14:41:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210517050141.61488-5-shenyang39@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 17-05-2021 07:01, Yang Shen wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:2040: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:1295: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c  | 2 +-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
