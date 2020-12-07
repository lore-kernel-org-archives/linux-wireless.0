Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B62FC35296
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ECCE238E7
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Dec 2020 16:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgLGQez (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:34:55 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:44725 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbgLGQex (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:53 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607358873; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OhEFrDEUFj7zT+CdilmOa380lzOsvUpPVMdgqGNjVWc=;
 b=WQxTNflOvX/0oBBZPvKAxkRP5gaQ/W5oFRw5lVVXelM4hfLO140kTPeLsBmF12a+6EU/a+zP
 wpAi4Fu/PvaLMqrnmM6MXXjKVR569bOJJq94OTNnENr0RONdtwVbVExd2ZShUElJENgV1pYg
 enGt78gKYPMQ9kvGpZyIu297r/0=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fce597ec0eb5c23b3c2c1d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 07 Dec 2020 16:34:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 738EAC433CA; Mon,  7 Dec 2020 16:34:06 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 814F0C43467;
        Mon,  7 Dec 2020 16:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 814F0C43467
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwifiex: change license text of Makefile and README from
 MARVELL to NXP
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1606814307-32715-1-git-send-email-ganapathi.bhat@nxp.com>
References: <1606814307-32715-1-git-send-email-ganapathi.bhat@nxp.com>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc:     linux-wireless@vger.kernel.org, Cathy Luo <xiaohua.luo@nxp.com>,
        James Cao <zheng.cao@nxp.com>,
        Rakesh Parmar <rakesh.parmar@nxp.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201207163406.738EAC433CA@smtp.codeaurora.org>
Date:   Mon,  7 Dec 2020 16:34:06 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ganapathi Bhat <ganapathi.bhat@nxp.com> wrote:

> As of 6-DEC-2019, NXP has acquired Marvell’s Wireless business
> unit. This change is to update the license text accordingly.
> 
> commit 932183aa35c6 ("mwifiex: change license text from MARVELL
> to NXP") does this, but it left out two files.
> 
> Signed-off-by: James Cao <zheng.cao@nxp.com>
> Signed-off-by: Cathy Luo <xiaohua.luo@nxp.com>
> Signed-off-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>

Patch applied to wireless-drivers-next.git, thanks.

5f27b9afe8e2 mwifiex: change license text of Makefile and README from MARVELL to NXP

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1606814307-32715-1-git-send-email-ganapathi.bhat@nxp.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

