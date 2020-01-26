Return-Path: <SRS0=/TLA=3P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6CEC2D0DB
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 11:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550702071E
	for <linux-wireless@archiver.kernel.org>; Sun, 26 Jan 2020 11:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vUpYCX9b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbgAZLiC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Jan 2020 06:38:02 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:18543 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387399AbgAZLiC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Jan 2020 06:38:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580038681; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=z6OBFw7GVflMeTBrP1hfcRpJ75xY8XDgYqiryF9ZC0Y=;
 b=vUpYCX9bKaX/qZ04OgkSPeYjm48G8PfczLIWLR6ytsP1QCDABsjef4asqbcjSzP4Hv8MxG6I
 btmN4U4zbevSt4wy/dUOnKPjDNMMa/t58CZLnrJJmu9jTCvrna1JWLET4SKpgb+ZtHtjpZJo
 OHIqy7HPi/38+L6eqtwV+5No6Eg=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2d7a16.7f0f2d56dc70-smtp-out-n03;
 Sun, 26 Jan 2020 11:37:58 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 67765C4479F; Sun, 26 Jan 2020 11:37:58 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 58C4FC43383;
        Sun, 26 Jan 2020 11:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 58C4FC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] MAINTAINERS: update for mwifiex driver maintainers
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1578912148-28796-1-git-send-email-ganapathi.bhat@nxp.com>
References: <1578912148-28796-1-git-send-email-ganapathi.bhat@nxp.com>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126113758.67765C4479F@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 11:37:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ganapathi Bhat <ganapathi.bhat@nxp.com> wrote:

> Remove Nishant Sarmukadam from Maintainer list, as he is no
> longer working in NXP.
> 
> Signed-off-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>

Patch applied to wireless-drivers-next.git, thanks.

d04bf42891a7 MAINTAINERS: update for mwifiex driver maintainers

-- 
https://patchwork.kernel.org/patch/11329921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
