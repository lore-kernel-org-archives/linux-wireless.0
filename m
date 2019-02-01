Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75661C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4588621872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZtKK09Ch";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ci2ZIGWN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfBAM0X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:26:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfBAM0X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:26:23 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 26B5C608CC; Fri,  1 Feb 2019 12:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023982;
        bh=JudtkUaNz6VUgUcJnqcqIqG6GU4NeUOrAcM15RscaOg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZtKK09ChEwrFdMGkk43yu2D0C9jASlYj5Q1FDhPQZbSHA3UEvXywatWbxuvqboSNT
         Tzq9kwOCst+UZgyWcC9KrR1emcqgp72zDDsBIJLY20VEDqPxxlPsfasU+j2l6hF1B6
         BFICrdofiQxu2AUmCVjSzmKdeEkJhNJmG11HlLnE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A4556043F;
        Fri,  1 Feb 2019 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023981;
        bh=JudtkUaNz6VUgUcJnqcqIqG6GU4NeUOrAcM15RscaOg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ci2ZIGWNqqSYjPXfLI5D59cEO67JQdZ/c0IrU+saEIGFNtOO+hzhl6kaYIbOmN1mP
         hTTtRAMFmSG1TOAmbakd8Nf615C9ABam1z0DgOURi4j/heW4Flv6D2Y5jbyAK5ctvz
         vd/aedh6MDaN0wY2Sv+k4Pg1za4YkOUtYeNTYs38=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A4556043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: remove unneeded semicolon
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190118033215.5904-1-yuehaibing@huawei.com>
References: <20190118033215.5904-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <arend.vanspriel@broadcom.com>,
        <franky.lin@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <pkshih@realtek.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201122622.26B5C608CC@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:26:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> remove unneeded semicolon
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Acked-by: Steve deRosier <derosier@cal-sierra.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

999eb686aa90 wireless: remove unneeded semicolon

-- 
https://patchwork.kernel.org/patch/10769393/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

