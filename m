Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC72C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 18:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD98721B68
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 18:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DWnqxdNL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QbAe10W2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390696AbfBNSh4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 13:37:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfBNShz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 13:37:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7C4FE608FD; Thu, 14 Feb 2019 18:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550169475;
        bh=nQhMpVFoCfyVXCvjsHYjXUxMg9hCBX9aSeZeHfMJIcM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DWnqxdNLmNNZ9Fty0t5ksFaZyRAzVjr+g34Hr/8WQJW50he1/iqB62w+r/3VaSHSm
         0LyTydNujxkg0d+zGsYaGaxCg2YNt+Ii1sW5SxR8ynwDcxTDiMCoRDfc4k8Q2fkQbn
         aGpETZLidQWRZSx7hy+eyylBYiOXJ5vl+NKyLzJI=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C50D60740;
        Thu, 14 Feb 2019 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550169474;
        bh=nQhMpVFoCfyVXCvjsHYjXUxMg9hCBX9aSeZeHfMJIcM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QbAe10W2ifO99iiW+avItgTAGqToiwRnc394VL2x+5M1Kdt5Ya8+LFE6ErInSeLKe
         CdBtxttjBImUNF9uGqHQ2zBsU2orBYpgLZYBjtdtxG3LJGG1dndRdNQKCN/lzEA0Hm
         tavm8HEkHvRr1yv5mXupIdJbMeFqGnbv0dG9H6pA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C50D60740
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com
Subject: Re: [PATCH v2 02/13] rtlwifi: btcoex: Replace old-style license information
References: <20190214170043.3705-1-Larry.Finger@lwfinger.net>
        <20190214170043.3705-3-Larry.Finger@lwfinger.net>
Date:   Thu, 14 Feb 2019 20:37:51 +0200
In-Reply-To: <20190214170043.3705-3-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Thu, 14 Feb 2019 11:00:32 -0600")
Message-ID: <87r2ca1aio.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> The old-style license information is replaced by the SPDX form. There
> are no code changes.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> v2 - C++ comment style used for SPDX line in .c files, and GPL 2.0+ changed to 2.0.

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h
> @@ -1,3 +1,6 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2016-2017  Realtek Corporation.*/
> +
>  /******************************************************************************
>   *
>   * Copyright(c) 2016-2017  Realtek Corporation.

You don't remove the license in this file.

-- 
Kalle Valo
