Return-Path: <SRS0=ngAs=TX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D727DC282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 09:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9143F20863
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 09:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aaHNUDBc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dLgD/J/I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEWJQY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 May 2019 05:16:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEWJQX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 May 2019 05:16:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0351761110; Thu, 23 May 2019 09:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558602983;
        bh=CITna12oDgxDKNY8Hlt8nIP8h5rIb7Ysvg54FZqViIA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aaHNUDBc7vJTIZBae9j43GR8CEMVru+kuyVXBGmXBSZI4B2yNQxOcf/nFVBe3y8rC
         2Gds1kSdjbfWFEGAjJW/X7wcyBOcrk/BHc4j7rMxlnpJNNigoARDwGUk3HwUkii1Ii
         rHQgPr1JDUEEYQPD1JtvU7qYceYoaMQnL+a0CHXY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A02B760FED;
        Thu, 23 May 2019 09:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558602981;
        bh=CITna12oDgxDKNY8Hlt8nIP8h5rIb7Ysvg54FZqViIA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dLgD/J/IqFDGoge8GREbogDVc4mzo1t/tB6oGa5X129GShMxkavbewXoql8si5ECS
         9oV44UOqe8mQSQ+JvfoanUHFq/jSaWGF6wPS6/sCgG+z/g1/2HcU2ZOzoKfBC7bYIA
         WUbEfKPqbrHKh/0vdvlPjAEWDZtGu4mAjPfJZnR4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A02B760FED
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/7] brcmsmac: switch source files to using SPDX license
 identifier
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1558008251-13692-4-git-send-email-arend.vanspriel@broadcom.com>
References: <1558008251-13692-4-git-send-email-arend.vanspriel@broadcom.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190523091623.0351761110@smtp.codeaurora.org>
Date:   Thu, 23 May 2019 09:16:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend van Spriel <arend.vanspriel@broadcom.com> wrote:

> With ISC license text in place under the LICENSES folder switch
> to using the SPDX license identifier to refer to the ISC license.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Dropped per discussion

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10946471/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

