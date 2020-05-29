Return-Path: <SRS0=6Pxi=7L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8907C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF11F2075A
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="H+0o+WMv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgE2RKy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 May 2020 13:10:54 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:47547 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbgE2RKx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 May 2020 13:10:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590772252; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=luhAvbFQS3u+cWg5MVZbslM9kRmOutZG5cw22hDZmXo=;
 b=H+0o+WMvbmHaKAKjbFuYIawASJIqcaomUMO6Yy2R+neFk8KXAwqU5h5SSyXwFSDNzmNQTWX+
 vG3kGNTyswQD5Kn/wguWpaiGzOGV8tV5byc/GdAUMaFybfWzX9AUyfeUPyIf0CZbvBnj1dY6
 DEL0c5eY8YKNV8AYRDEEgashXQg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5ed1421237a454afcb357377 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:10:42
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 740EAC433C6; Fri, 29 May 2020 17:10:42 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB840C433CA;
        Fri, 29 May 2020 17:10:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB840C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] MAINTAINERS: update qtnfmac maintainers
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200520130800.1902-1-sergey.matyukevich.os@quantenna.com>
References: <20200520130800.1902-1-sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     linux-wireless@vger.kernel.org,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Mikhail Karpenko <mkarpenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529171042.740EAC433C6@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:10:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> I am leaving Quantenna, so I will no longer have access to firmware and
> hardware. Meanwhile I plan to participate in reviewing qtnfmac patches
> for a while until my firmware knowledge becomes completely obsolete.
> Adding myself as a reviewer using my personal email address.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

3a8855d8cfcb MAINTAINERS: update qtnfmac maintainers

-- 
https://patchwork.kernel.org/patch/11560401/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

