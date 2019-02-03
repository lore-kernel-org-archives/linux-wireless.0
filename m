Return-Path: <SRS0=ytbo=QK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E18C169C4
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Feb 2019 19:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE84721773
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Feb 2019 19:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U25TSLhI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B77+COQG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfBCTma (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Feb 2019 14:42:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfBCTm3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Feb 2019 14:42:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F0EB860746; Sun,  3 Feb 2019 19:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549222949;
        bh=pInt3iP4PRZ2W8rAD6kj3RN5ygGRUNcw+hq/kKgbCkc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U25TSLhIi2Ayzer49gJmwt+HmFnQvwmzFa9mHl3JVW7jgLi2+gwk3Mv8ACAZeUPcI
         GkhUF9cYvK+hPbAS7iN8h8PNpgiXccRqQNYWjGPE7kXc7MFYz4370QS3xapDPnthyc
         0RflNuWU26eFKooDlmfKAzq7X50kmpqBSV8U5Irw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F97C6032C;
        Sun,  3 Feb 2019 19:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549222948;
        bh=pInt3iP4PRZ2W8rAD6kj3RN5ygGRUNcw+hq/kKgbCkc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=B77+COQGq0jn6asHWGZBfzH3lvu3HFCkh4xo8+BcOKLVgn3Y2QartiQ3gM4JG+CU2
         4iZbssMbxiCBQT3iOEVeTkrI0SrX3HeevX6n8dEitphC7IKtsiIdgP9pfmujHKDLFC
         JzrQdttBEk6UXqIy7SGnFY7t7IfsmqfQW+jJXtVo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7F97C6032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] MAINTAINERS: add entry for redpine wireless driver
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549019120-9376-1-git-send-email-siva8118@gmail.com>
References: <1549019120-9376-1-git-send-email-siva8118@gmail.com>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190203194228.F0EB860746@smtp.codeaurora.org>
Date:   Sun,  3 Feb 2019 19:42:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> Create an entry for Redpine wireless driver and add Amit and myself as
> maintainers.
> 
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Patch applied to wireless-drivers.git, thanks.

8c22d81d5535 MAINTAINERS: add entry for redpine wireless driver

-- 
https://patchwork.kernel.org/patch/10792501/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

