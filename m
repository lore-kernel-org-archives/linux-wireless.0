Return-Path: <SRS0=MvhY=57=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46972C2BA19
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Apr 2020 17:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F350206F9
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Apr 2020 17:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lcRxFwyN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404689AbgDORCv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Apr 2020 13:02:51 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:44236 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404661AbgDORCu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Apr 2020 13:02:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586970169; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=nDpbf+oKOTLzufE28klKD6wsmPoDbXY1+0uUYjubRkk=;
 b=lcRxFwyNwR9U1Fo4rB3l8pKiuwsfjTeZuRwHH01t09xJ+QfyvjUMmPcpYcdXeflOWy+EWk2Z
 HN/OhzOk/2T8kdkuJT+shCtBCJ7sYiQa8FMEnaBMlgxIPT0lj68DxbDqOeLRmosfd0JHsdR0
 ijPhkdS6aKsgZFVkxqlotZs6KmQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e973e38.7f8e74f637a0-smtp-out-n04;
 Wed, 15 Apr 2020 17:02:48 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 58A19C433CB; Wed, 15 Apr 2020 17:02:47 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25B16C433F2;
        Wed, 15 Apr 2020 17:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 25B16C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] brcmfmac: remove leading space
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200412171900.xzedxhzd56gox5kf@nixos>
References: <20200412171900.xzedxhzd56gox5kf@nixos>
To:     Nils =?utf-8?q?ANDR=C3=89-CHANG?= <nils@nilsand.re>
Cc:     trivial@kernel.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200415170247.58A19C433CB@smtp.codeaurora.org>
Date:   Wed, 15 Apr 2020 17:02:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nils wrote:

> Signed-off-by: Nils ANDRÉ-CHANG <nils@nilsand.re>

Patch applied to wireless-drivers-next.git, thanks.

f0f383347ced brcmfmac: remove leading space

-- 
https://patchwork.kernel.org/patch/11484825/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
