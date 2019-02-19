Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1106C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1C3521736
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Zu3arZHy";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l9QeWegM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfBSPBy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:01:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56486 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfBSPBy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:01:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D054660779; Tue, 19 Feb 2019 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588513;
        bh=CifNEVbUqtkre6gxRVpo3xax57KFk0C44KK6xfG5IpY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Zu3arZHyURUzz+PRKfb2J7BcaVtHWGKjUmIxFRgLLJtNRSNYtvcde2fcMADtli4yi
         3h9vzGK9b9uQd9s0adh2FzOpWMEatVjRjKpumsdttCuM/1TiOuuJXLbfhqCLOSoBjb
         QnJ6EShK97/5+fVuzVC9A3/Amqwc8EmRMS2IhZZE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5D8E8602C3;
        Tue, 19 Feb 2019 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588513;
        bh=CifNEVbUqtkre6gxRVpo3xax57KFk0C44KK6xfG5IpY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=l9QeWegM6LbEFcuUvB7k02JEEKJYw/tGjMrSdLUmew815ScwWHqmkZMgbXL3jPUxA
         WwWgDaCP+qmuETe5P75dX1GZT3VpC2WIKALJsrF9B8spKhea+YeCfljfoKtTuofqhy
         YeylWuuV3pGShtrQZMB8Gk/W7ntfPTfiPcQWzVOQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5D8E8602C3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 01/13] rtlwifi: Replace old-style license information
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190214195920.1504-2-Larry.Finger@lwfinger.net>
References: <20190214195920.1504-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150153.D054660779@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:01:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The traditional license information is replaced by the SPDX form. There
> are no code changes.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

13 patches applied to wireless-drivers-next.git, thanks.

d27a76fa5a66 rtlwifi: Replace old-style license information
8c0863125229 rtlwifi: btcoex: Replace old-style license information
fbb352862190 rtlwifi: rtl8188ee: Replace old-style license information
e70113691804 rtlwifi: rtl8192com: Replace old-style license information
0770f718458e rtlwifi: rtl8192ce: Replace old-style license information
b44febedbb8d rtlwifi: rtl8192cu: Replace old-style license information
5bd4f692e0eb rtlwifi: rtl8192de: Replace old-style license information
647f21b10292 rtlwifi: rtl8192ee: Replace old-style license information
6f3fcdc88e53 rtlwifi: rtl8192se: Replace old-style license information
48fa0b4d58dc rtlwifi: rtl8723ae: Replace old-style license information
93121c03e0ce rtlwifi: rtl8723be: Replace old-style license information
2a7274ee12cc rtlwifi: rtl8723_common: Replace old-style license information
03f3dd37f095 rtlwifi: rtl8821ae: Replace old-style license information

-- 
https://patchwork.kernel.org/patch/10813683/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

