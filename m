Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7FBC48BDF
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jun 2021 09:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A704613F2
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jun 2021 09:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhFXJ16 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jun 2021 05:27:58 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20291 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhFXJ16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jun 2021 05:27:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624526739; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=WSMP7AkbOa6vVP5f3JZN2gDl8XjM3iiAev0k5XvkaTU=; b=DT5qsSEWhYjTfiSRgwI9n30HxS9YZhxVsZ2m0bG6g4vECWS6Tw5Ye4TlWqzXAUj1a0QnnVZI
 uW5LRR/rsyOh9aoPF7Z0amXFfT9Vdtn+g0D2IxJNeDO0nlXqH+ToL/cTXYu40LDrNG6qit0b
 x4QAK8eNg58IuKrsyXxpo+aGtjo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60d44f835d0d101e38d5c47c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 09:25:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39F88C433D3; Thu, 24 Jun 2021 09:25:23 +0000 (UTC)
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D5FD7C433D3;
        Thu, 24 Jun 2021 09:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D5FD7C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 03/12] wilc1000: added new WID to pass WOW info to firmware
References: <20210423182925.5865-1-ajay.kathat@microchip.com>
        <20210423182925.5865-4-ajay.kathat@microchip.com>
Date:   Thu, 24 Jun 2021 12:25:18 +0300
In-Reply-To: <20210423182925.5865-4-ajay.kathat@microchip.com> (Ajay Kathat's
        message of "Fri, 23 Apr 2021 18:29:42 +0000")
Message-ID: <87mtrfiphd.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Ajay.Kathat@microchip.com> writes:

> From: Ajay Singh <ajay.kathat@microchip.com>
>
> Added new WID to handle WOW and pass the information to FW in
> wilc_set_wakeup().

The commit log does not answer to "Why?". If you are fixing a bug,
please describe the issue.

And use imperative voice: "added" -> "add"

Please read the wiki which contains more information:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_messages

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
