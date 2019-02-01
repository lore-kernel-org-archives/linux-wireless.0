Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCC1C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41C021872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i2lhvIIB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KYE3ZF/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfBAKAW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:00:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfBAKAW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 05:00:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7A8E360867; Fri,  1 Feb 2019 10:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549015221;
        bh=SgJ9lFppbhDK5fuSvciCAANbjq8O/3FClAu4Ova19FM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=i2lhvIIBJAcvs+i7AH8xtDfep62Ov1PEBI/q/+y+zBgZ5qWI8H8K0eD3f3TNRLSC/
         68k8/IGdOY1OeTZAMrF31nlWh1WMnxLdeHjTiPoS0kuJzsTjjWsUo5MlZ6+slG8/2T
         7gLesWkX7+A/Seq26kEc0fGU9j+F3nESlqZ8MfAU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D2486043F;
        Fri,  1 Feb 2019 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549015220;
        bh=SgJ9lFppbhDK5fuSvciCAANbjq8O/3FClAu4Ova19FM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KYE3ZF/6Wq6CSVDzxE0gy0IrylhIVtxVT7VWoyMr3CXsGmEuPFFNnKhen/FAbqOS3
         l90QStW6KytvxyoNktqN1cNssy/6azgd5kmkjNpy3fGkJxRm0rPNay6ptAwlsV0RxE
         /6oOkDltEpxhGmRlGMCbuf2xpCj3MEVtJfxqAP6M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D2486043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for redpine wireless driver
References: <1549014070-3930-1-git-send-email-siva8118@gmail.com>
Date:   Fri, 01 Feb 2019 12:00:16 +0200
In-Reply-To: <1549014070-3930-1-git-send-email-siva8118@gmail.com> (Siva
        Rebbagondla's message of "Fri, 1 Feb 2019 15:11:10 +0530")
Message-ID: <87tvhnhlqn.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> writes:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>
> Create an entry for Redpine wireless driver and add Amit and myself as
> maintainers.
>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 32d44447..c4e8fb4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16923,6 +16923,13 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	mm/zswap.c
>  
> +REDPINE WIRELESS DRIVER
> +M:	Siva Rebbagondla <siva8118@gmail.com>
> +M:	Amitkumar Karwar <amitkarwar@gmail.com>
> +L:	linux-wireless@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/wireless/rsi/
> +
>  THE REST
>  M:	Linus Torvalds <torvalds@linux-foundation.org>
>  L:	linux-kernel@vger.kernel.org

Like documented in the beginning of the file these should be in
alphabetical order. Please fix and resend.

-- 
Kalle Valo
