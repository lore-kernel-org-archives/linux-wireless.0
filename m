Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70F9C48BDF
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jun 2021 09:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEEBA613F7
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jun 2021 09:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhFXJob (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jun 2021 05:44:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:44272 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231878AbhFXJo3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jun 2021 05:44:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624527730; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=pzB7kxIWXAQKBwd8Zm1muzy7YpTa41SoD2dloL7BYcI=; b=pBZ7vr8dB3R8JdQcwOvoCifQ1l27gNK4O+9zWZ5JIIxtrORc2+00KT1+HXrnOc2+x/KDebVQ
 NzjhAvzRQ+nLfvpqUM+A+N9IgKVq+k29p6XhtO5nWVojmsdcAUJrGi83SuBJOSsNU6Ipb0hl
 EJsfq9pbtVFKSznX7txykFoE3NE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60d4535e4ca9face34d5af0a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 09:41:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 50C15C4338A; Thu, 24 Jun 2021 09:41:49 +0000 (UTC)
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A92BC433F1;
        Thu, 24 Jun 2021 09:41:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A92BC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 10/12] wilc1000: added initialized variable check before processing
References: <20210423182925.5865-1-ajay.kathat@microchip.com>
        <20210423182925.5865-11-ajay.kathat@microchip.com>
Date:   Thu, 24 Jun 2021 12:41:45 +0300
In-Reply-To: <20210423182925.5865-11-ajay.kathat@microchip.com> (Ajay Kathat's
        message of "Fri, 23 Apr 2021 18:29:49 +0000")
Message-ID: <871r8riopy.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Ajay.Kathat@microchip.com> writes:

> From: Ajay Singh <ajay.kathat@microchip.com>
>
> Added initialization success check before adding net/mgmt packet to Tx
> queue and processing wilc_get_statistics() command to FW.

Why?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
