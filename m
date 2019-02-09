Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77094C4151A
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 06:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4528D21903
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 06:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mC8U++JG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mC8U++JG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfBIGCn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 01:02:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40222 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfBIGCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 01:02:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AC691607DF; Sat,  9 Feb 2019 06:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549692162;
        bh=SkdPA7MLvbMXdrw0Cj7SXn0BBlXlrxz4qQKB83uWsLY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mC8U++JGvmUOrZG3odt8dP6+bQDRtRXKITSnxExB6ddUvnf1fIw2zqYdPUZAAhYet
         0+w5RM5ra3NOET51T/GqJ1JYkuqnzCynnTc/ypHZemBDgT6cTVVRm3OMFQIp2BVJyr
         Opajqlhr4pEa0IWci8KbaylgyRvwXJQaXzd+yAaE=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 29CAE601D7;
        Sat,  9 Feb 2019 06:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549692162;
        bh=SkdPA7MLvbMXdrw0Cj7SXn0BBlXlrxz4qQKB83uWsLY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mC8U++JGvmUOrZG3odt8dP6+bQDRtRXKITSnxExB6ddUvnf1fIw2zqYdPUZAAhYet
         0+w5RM5ra3NOET51T/GqJ1JYkuqnzCynnTc/ypHZemBDgT6cTVVRm3OMFQIp2BVJyr
         Opajqlhr4pEa0IWci8KbaylgyRvwXJQaXzd+yAaE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 29CAE601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com
Subject: Re: [PATCH 01/13] rtlwifi: Replace old-style license information
References: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
        <20190208172209.28530-2-Larry.Finger@lwfinger.net>
Date:   Sat, 09 Feb 2019 08:02:37 +0200
In-Reply-To: <20190208172209.28530-2-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Fri, 8 Feb 2019 11:21:57 -0600")
Message-ID: <87tvhd33eq.fsf@codeaurora.org>
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

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -1,27 +1,5 @@
> -/******************************************************************************
> - *
> - * Copyright(c) 2009-2012  Realtek Corporation.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of version 2 of the GNU General Public License as
> - * published by the Free Software Foundation.

So the way I see this is GPLv2 only (so GPLv3 is not included).

> +/* SPDX-License-Identifier: GPL-2.0+ */

But this is GPLv2 or later (including GPLv3 for example).
LICENSES/preferred/GPL-2.0 contains more info about the tags.

Also for SPDX tags in .c files you should use C++ comment style '//',
BUT in .h files normal C comment style '/* */'. Confusing, I know :/

https://www.kernel.org/doc/html/latest/process/license-rules.html#license-identifier-syntax

-- 
Kalle Valo
