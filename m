Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D4FC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 06:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAB1B20869
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 06:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mBM9CmeV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TFJUR5W7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfBIGIp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 01:08:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfBIGIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 01:08:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0E8BA607DD; Sat,  9 Feb 2019 06:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549692524;
        bh=7EItZjZ7K4pz+sHMBQGWLPdxBtD9S1Gw9GCemUdtKFc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mBM9CmeVFwTHfvdVe+nGpBFnOWDD/t4SNGsZ7GNgOsJgISDj9yuOK0xzj2xbdDKe3
         9mFSQGBvTyAjkVnBeDa0kE/pwrMF8h9dfysbg42IolOk+/rFw15cV1C0Ph5mTgYaIT
         G/kjy6jcTyU2xQNx8YB8gWGT6RtogLovVwXjAuV4=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D2AA96032C;
        Sat,  9 Feb 2019 06:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549692523;
        bh=7EItZjZ7K4pz+sHMBQGWLPdxBtD9S1Gw9GCemUdtKFc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TFJUR5W7sKUlb1w011Vr4AyS+1/PBlywoFZvwkh3U/PrU6nUFuzmpQt1eWV7tdPWi
         aPIrFOVCvUy9IUQFidk/gE0bhsFScVealxaGRCuRGFG6cPD6Cvwq/3SQnu1cXWOEsu
         HpvAlorkn+JbAnHd1RNKei8M0s95qRIlQHsmoLyw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D2AA96032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com
Subject: Re: [PATCH 01/13] rtlwifi: Replace old-style license information
References: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
        <20190208172209.28530-2-Larry.Finger@lwfinger.net>
        <87tvhd33eq.fsf@codeaurora.org>
Date:   Sat, 09 Feb 2019 08:08:40 +0200
In-Reply-To: <87tvhd33eq.fsf@codeaurora.org> (Kalle Valo's message of "Sat, 09
        Feb 2019 08:02:37 +0200")
Message-ID: <871s4hsdcn.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> The traditional license information is replaced by the SPDX form. There
>> are no code changes.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> [...]
>
>> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
>> @@ -1,27 +1,5 @@
>> -/******************************************************************************
>> - *
>> - * Copyright(c) 2009-2012  Realtek Corporation.
>> - *
>> - * This program is free software; you can redistribute it and/or modify it
>> - * under the terms of version 2 of the GNU General Public License as
>> - * published by the Free Software Foundation.
>
> So the way I see this is GPLv2 only (so GPLv3 is not included).
>
>> +/* SPDX-License-Identifier: GPL-2.0+ */
>
> But this is GPLv2 or later (including GPLv3 for example).
> LICENSES/preferred/GPL-2.0 contains more info about the tags.
>
> Also for SPDX tags in .c files you should use C++ comment style '//',

Oh, but do not that '//' should be used only with the first line
containing the SPDX tag (in a .c file). The following lines with
copyrights should use '/* */' normally.

-- 
Kalle Valo
