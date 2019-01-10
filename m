Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A64BC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 07:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B4B4214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 07:37:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IQdwhI1I";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KqMXe4Os"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfAJHhm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 02:37:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfAJHhl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 02:37:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 05CB5608A5; Thu, 10 Jan 2019 07:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547105861;
        bh=YcetAD6jqBwJ4B+s2G9APBdE5lh6HTMtgGJRZX8gyGc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IQdwhI1IP5SGdxjVx/9xzcUax8ZEkSYZeibkj40efPbX/JWCoMQf/Fodg+hDOtU1s
         Nj95LpV634i2Lu6LFrPwKWfuc0sB6JfTXsHUbQ19fszss4T8YNT7MyUeFZ2D8UjSfk
         4/QuPBL4a4IXfonvlmLlt4Amll39xwq5Ce3sR6Nk=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1424260132;
        Thu, 10 Jan 2019 07:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547105860;
        bh=YcetAD6jqBwJ4B+s2G9APBdE5lh6HTMtgGJRZX8gyGc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KqMXe4Os+LerPXQPbP7vUUV0OWFzzRalxMcEbrjcPeCugVSDjv7LMR3fCxH30Ndhv
         uX0yoqbsGndAGGpjrxjLJJq3vUC/ZhV3CqHESeErPEp16rjWWzHfJ29d6g9WhYp2ud
         GuY2McPpKCj6fWtB7wHq4Q9bJFDO5X3+RIVZoPMo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1424260132
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: Re: [PATCH 6/7] qtnfmac: convert to SPDX license identifiers
References: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
        <20190109160843.14832-7-sergey.matyukevich.os@quantenna.com>
Date:   Thu, 10 Jan 2019 09:37:37 +0200
In-Reply-To: <20190109160843.14832-7-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Wed, 9 Jan 2019 16:09:04 +0000")
Message-ID: <875zux6jzy.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Replace textual license with SPDX-License-Identifier.
> Add an SPDX-License-Identifier for the Makefile.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[...]

> --- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
> +++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
> @@ -1,3 +1,6 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/* Copyright (c) 2015-2016 Quantenna Communications. All rights reserved. */
> +
>  /*
>   * Copyright (c) 2015-2016 Quantenna Communications, Inc.
>   * All rights reserved.

This doesn't look correct, please check.

-- 
Kalle Valo
