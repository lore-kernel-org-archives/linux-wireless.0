Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DD9C433FE
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Dec 2020 18:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB58E23118
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Dec 2020 18:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390620AbgLJSyt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Dec 2020 13:54:49 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:22337 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392334AbgLJSuw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Dec 2020 13:50:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607626232; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=zOWCArwGZT8tWhKzawFXE2/2SfQMZq6/kYe7gPZhKWk=;
 b=GxUKX81xho62nKa3xVBIVUq4Jn8HFGEdSBY5iVgfj9e2tka1ZBeFvJKs9ynN0i3cW+40fKFg
 DnuLtQ9FgDC7q5BQ0xxcx1Vz6tuNNiCpXp/4nsYMku4Njcznycl5MgsyBc3WVKb2BkN1v5xr
 uRRo+/lbZLdPh3V/AMhNgsLqNFg=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fd26dda53d7c5ba6054bc6e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Dec 2020 18:50:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 10F2FC43464; Thu, 10 Dec 2020 18:50:02 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0DB19C433C6;
        Thu, 10 Dec 2020 18:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0DB19C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless -next] cw1200: txrx: convert comma to semicolon
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201209135550.2004-1-zhengyongjun3@huawei.com>
References: <20201209135550.2004-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <pizza@shaftnet.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201210185002.10F2FC43464@smtp.codeaurora.org>
Date:   Thu, 10 Dec 2020 18:50:02 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> wrote:

> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

c42d492c672a cw1200: txrx: convert comma to semicolon

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201209135550.2004-1-zhengyongjun3@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

