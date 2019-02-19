Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E33C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3562021736
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IavqmZPS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Uud9rfOO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfBSPJU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:09:20 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37674 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfBSPJU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:09:20 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 321B26098C; Tue, 19 Feb 2019 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588959;
        bh=Vro9gWH7HSlxNS9fNoBc3KEv/qpJhcz69/q1w3Y40gE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IavqmZPSQVqw5Wlzs17zXeVlwPGSGDgvsRAJ68NKAYkh1Z2FmM+ZltInE5+qKqStt
         +aJ5Gabn0xR6fHPQnxILMpGAwxZ58QMrspEQHFTXVXMiGSLIzqrMiFMNCU/rv1a5Fz
         B5UksQ6d0jZjBnoGsqnihYTDy1Wubtl7/QxI2bWg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FE9960A74;
        Tue, 19 Feb 2019 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588955;
        bh=Vro9gWH7HSlxNS9fNoBc3KEv/qpJhcz69/q1w3Y40gE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Uud9rfOOmNcsuSrCWfWRpdIxBNTHGxbAMkBoVdFYhPajlKEwhvisFcyddkuTRx35a
         UJSf9hclTqf6UM+avxUknsvmPdTnsev+UWDBwqhtyqZIXKrdVyJchbnmp4H39kdNuV
         hZBO5e0mhfQkI/gxbaYu7JSNWfj56H4HcLE3jzSE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FE9960A74
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix spelling mistakes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549970914-3880-1-git-send-email-siva8118@gmail.com>
References: <1549970914-3880-1-git-send-email-siva8118@gmail.com>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        siva.rebbagondla@redpinesignals.com,
        rishikesh.basu@redpinesignals.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150919.321B26098C@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:09:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> Trivial fixes to spelling mistakes in various files in rsi folder.
> 
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Patch applied to wireless-drivers-next.git, thanks.

b9c767fdde61 rsi: fix spelling mistakes

-- 
https://patchwork.kernel.org/patch/10807785/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

