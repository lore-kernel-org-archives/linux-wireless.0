Return-Path: <SRS0=Fczi=EE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7D6C55179
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDFF820878
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="NhGCS/3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgJ2CFg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Oct 2020 22:05:36 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:58426 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgJ1ViU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Oct 2020 17:38:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603921100; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=/kOV9eLx6Jma6oBz8tUemmC4ZI0OlHRbmHAdnE7Ewkg=;
 b=NhGCS/3bnXD5GHJypR+PcDE5VbYJjFojqcTROK5OmU09i9AHZogh3d/SpzVFTcHesLjdEsGs
 qOpHLQPyh6T+b21qMdwZ/xoRMtFMpcaGlHyiT8zIvEm6iMPIOmkgCQF5dQnVRwBdMIHQC8/8
 wCzH+pXIZfxpjn5ybcdf6dcdYFg=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f99754eaca26e7bb9522abd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 28 Oct 2020 13:42:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3AE5C433FF; Wed, 28 Oct 2020 13:42:37 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BFC36C433C9;
        Wed, 28 Oct 2020 13:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BFC36C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: remove repeated words in comments
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1603802288-21158-1-git-send-email-kvalo@codeaurora.org>
References: <1603802288-21158-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201028134237.F3AE5C433FF@smtp.codeaurora.org>
Date:   Wed, 28 Oct 2020 13:42:37 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> Found by latest checkpatch.
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

762fd1aec588 ath10k: remove repeated words in comments
d2f3f68864a4 ath10k: ath10k_pci_init_irq(): workaround for checkpatch fallthrough warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1603802288-21158-1-git-send-email-kvalo@codeaurora.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

