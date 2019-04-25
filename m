Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A79C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73DC020693
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nPYeImwr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oM3nIiNl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfDYQl7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:41:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54810 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbfDYQl6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:41:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1DAEA6077A; Thu, 25 Apr 2019 16:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210518;
        bh=cBGrE0tNyEORjVUrV361DVtDQFf/TpOQ9BuybZrugGY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nPYeImwrUrbbYpOeeii8EVPg/GutNLRTCgC3pRegjyKelGbkNCpzruEotslcbSEXb
         MeJjYMLf1Emus8HG0GXxBJIIlusIalrjkX7zc26vtVe1zTPaBKn3mmwt6gUjS/uEfY
         G4QDY1g1mvd4NXCcWz1OkBKgGNfIzxoUPJ7BZ52M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D5BB6019D;
        Thu, 25 Apr 2019 16:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210517;
        bh=cBGrE0tNyEORjVUrV361DVtDQFf/TpOQ9BuybZrugGY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oM3nIiNloAearAVpgzVvroCy2pjHtj3VFEvIfvAgnDEcQkVBSsKbd23DCq5RvcIUb
         XP1ZAP9YQOJfXKDQgCFX3bXPyODcjxMiiF2cYP4FYAExS8C37wpSlm2604rI2CyYgB
         AVVuRV48QqSobdvKIg8Z8M7RCNbNCEp50edc5cX8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4D5BB6019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rt2x00: code-style fix in rt2800usb.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1552573160-3268-1-git-send-email-pozega.tomislav@gmail.com>
References: <1552573160-3268-1-git-send-email-pozega.tomislav@gmail.com>
To:     =?utf-8?q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425164158.1DAEA6077A@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:41:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tomislav Požega wrote:

> Remove space leftovers.
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

9490c5602445 rt2x00: code-style fix in rt2800usb.c

-- 
https://patchwork.kernel.org/patch/10852955/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

