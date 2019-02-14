Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F998C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 18:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A0BD206C0
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 18:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="V+Qe1Y65";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c0xol6ap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbfBNSd4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 13:33:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730385AbfBNSdz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 13:33:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D96160740; Thu, 14 Feb 2019 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550169235;
        bh=Vam7Pm9R18WM/TWb2ZbMkSavK+VOiUi3flYvDh13RQU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=V+Qe1Y65A8sYCRDg1sV/J7c4HU3sF7gtyEYy+rBCpkK2UDpQFp6T9y9Gid3bykRpm
         OM8Jh+RkhRdnTgabGzN2/QfcfXI3qEnsHXBfI6KHtx8YXzDCHxmR7+ycsTwD3OqQmO
         choPxYucl3Nm4XA80n7XaGnWDp7BZlbJngVhWFK8=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69D9C60397;
        Thu, 14 Feb 2019 18:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550169234;
        bh=Vam7Pm9R18WM/TWb2ZbMkSavK+VOiUi3flYvDh13RQU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=c0xol6apdAb/HakuHuaSsnpEXUMyaMT9jgetwszFZ8zYesqTsVX0DLbpNAT8+7OAh
         SVie2r1isrk7YnBtd7DVgDmqg3huZFW73FK2TNNNYsrSTCAvewtShiGsyQBz98w7YN
         1wpj9gQcmZsf3xNwdlNgcwMaBiBEN08traDdNSbs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 69D9C60397
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com
Subject: Re: [PATCH v2 01/13] rtlwifi: Replace old-style license information
References: <20190214170043.3705-1-Larry.Finger@lwfinger.net>
        <20190214170043.3705-2-Larry.Finger@lwfinger.net>
Date:   Thu, 14 Feb 2019 20:33:50 +0200
In-Reply-To: <20190214170043.3705-2-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Thu, 14 Feb 2019 11:00:31 -0600")
Message-ID: <87va1m1apd.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> The traditional license information is replaced by the SPDX form. There
> are no code changes.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> v2 - C++ comment style used for SPDX line in .c files, and GPL 2.0+ changed to 2.0.

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -1,27 +1,5 @@
> -/******************************************************************************
> - *
> - * Copyright(c) 2009-2012  Realtek Corporation.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of version 2 of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * The full GNU General Public License is included in this distribution in the
> - * file called LICENSE.
> - *
> - * Contact Information:
> - * wlanfae <wlanfae@realtek.com>
> - * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
> - * Hsinchu 300, Taiwan.
> - *
> - * Larry Finger <Larry.Finger@lwfinger.net>
> - *
> - *****************************************************************************/
> +// SPDX/-License-Identifier: GPL-2.0

Now some of the files have that extra slash in 'SPDX/'.

-- 
Kalle Valo
