Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1786C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 06:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FCBC2084D
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 06:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CtHhDo7p";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hhN+W4gr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfBKGNB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 01:13:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKGNA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 01:13:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7CF03601C4; Mon, 11 Feb 2019 06:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549865579;
        bh=QSCWo3myd9rw235N+ghKCosnt3d1cWY3+YpgMoWMvSI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CtHhDo7pQaoujkE1+rTY/yzmpKZfIDNPcP+VBkHSZG7jXBLR7YSOydqfDIW0JXajh
         ZcYAwpvreCXi1cVN887KlSyqrkABWHFRI+byKrI5FiEgOkmb1mDrDqBvfAJS6damKZ
         vqTkJJKGAhJZUcm5SGDPuvR+bGaGbkIm+hLFjHbo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F0681601C4;
        Mon, 11 Feb 2019 06:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549865577;
        bh=QSCWo3myd9rw235N+ghKCosnt3d1cWY3+YpgMoWMvSI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hhN+W4gr+lblluiJphewlLfSUTvTnAo4Jv++tFldWXXXYfgmYMC+9y9F2M0TBq4xR
         BUxcOY+VIDQcbG6FogzJ3hPrWd07pTyHB9QtxaH4CVFD5D3T2TRETQIUJSEzYWFvt7
         kTsSYInJch8YUuBcvqe5So/9ZDSxmmpYoiowKdf8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F0681601C4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        ath10k@lists.infradead.org
Subject: Re: linux-next: Signed-off-by missing for commit in the wireless-drivers-next tree
References: <20190211072814.7428f192@canb.auug.org.au>
Date:   Mon, 11 Feb 2019 08:12:52 +0200
In-Reply-To: <20190211072814.7428f192@canb.auug.org.au> (Stephen Rothwell's
        message of "Mon, 11 Feb 2019 07:28:14 +1100")
Message-ID: <87lg2m7t0b.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ ath10k

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> Commit
>
>   768ec4c012ac ("ath10k: update HOST capability qmi message")
>
> is missing a Signed-off-by from its author.

Oh, I had missed that. Thanks for reporting.

Unfortunately it would be difficult to rebase wireless-drivers-next so I
can't (easily) fix this. But v1 had s-o-b so at least we have the sign
off publically available:

https://patchwork.kernel.org/patch/10688563/

-- 
Kalle Valo
