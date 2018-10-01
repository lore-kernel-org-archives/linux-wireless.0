Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3CCC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A17DE20652
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CF4xtYLW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KPRhi46J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A17DE20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbeJAWJI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:09:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59706 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729480AbeJAWJI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:09:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4102060B7A; Mon,  1 Oct 2018 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538407847;
        bh=l8aNZEuWAz07S8+a9rDyS/NsudHkgTiKvvy6/GyJmeA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CF4xtYLWy8wNRLpntqmxw7vKC0qtc9rNXq8mrxDVKCcPyTNu+T9Nip7EcEnefTrrW
         q18malUT/1PuC6zzOtXPwdbpExffKDbJuZVNgBepJT5eN1F+Q4t6F3rdqpw1g/eljg
         yEOutFpvLjIE+Eay3/PIGV8HC5x8QjqmBw3UYB4s=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8689A60265;
        Mon,  1 Oct 2018 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538407846;
        bh=l8aNZEuWAz07S8+a9rDyS/NsudHkgTiKvvy6/GyJmeA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KPRhi46JyaX2vHtzPM+4l+/+03KsrwGirlRrXiZfcRVKDBfilG9AiSMw4aFbxsMdS
         jSI6OmVpLVFvYpDhO8sDxOppOenZSjVGS2FLuIs0TsOPS78FaIAnG8ag17j7KKnQJZ
         bGjgfYVS/7eUy+T9+ruej1iMABXu/H/nAJMrw0jo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8689A60265
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: Remove unnecessary parentheses
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180920204548.2405-1-natechancellor@gmail.com>
References: <20180920204548.2405-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001153047.4102060B7A@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:30:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns when multiple pairs of parentheses are used for a single
> conditional statement.
> 
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: warning: equality
> comparison with extraneous parentheses [-Wparentheses-equality]
>                 if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
>                      ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: note: remove
> extraneous parentheses around the comparison to silence this warning
>                 if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
>                     ~                    ^               ~
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: note: use '=' to
> turn this equality comparison into an assignment
>                 if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
>                                          ^~
>                                          =
> 1 warning generated.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/134
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

c15ace868dd1 ipw2x00: Remove unnecessary parentheses

-- 
https://patchwork.kernel.org/patch/10608735/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

