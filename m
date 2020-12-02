Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B524EC71155
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Dec 2020 19:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4C522240
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Dec 2020 19:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgLBTka (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Dec 2020 14:40:30 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:63786 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgLBTk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Dec 2020 14:40:29 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606938004; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Mtl9wQ9GjF50ma9005JT6p64/gylpChgOxe5IKtF7Tc=;
 b=UCk485cuuUPJHdi2V6kll64p7Gjru26nYTLrv0DZY3Bqr6W1ss9ya2ZqPMYAXD9UxDrwSIxe
 3BIU/JGrCjWqY3D+WXB+llD+xrGDLTFrfs8OBF2Nqsp/Gm6ZR4O00vnCbb0ETrtXiPnSk6LD
 GkXP1NhXDRl+o5kWS3jvxVIf8u4=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fc7ed79875646f1e9d80bfd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 19:39:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2408AC433C6; Wed,  2 Dec 2020 19:39:37 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 20E54C433C6;
        Wed,  2 Dec 2020 19:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 20E54C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wl1251: remove trailing semicolon in macro definition
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201127180835.2769297-1-trix@redhat.com>
References: <20201127180835.2769297-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201202193937.2408AC433C6@smtp.codeaurora.org>
Date:   Wed,  2 Dec 2020 19:39:37 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

fc6877b87982 wl1251: remove trailing semicolon in macro definition

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201127180835.2769297-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

