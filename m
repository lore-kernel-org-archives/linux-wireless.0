Return-Path: <SRS0=CJfu=43=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96499C18E5B
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Mar 2020 13:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6600E20675
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Mar 2020 13:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="iLUE7585"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgCJNfE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Mar 2020 09:35:04 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:35151 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727196AbgCJNfD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Mar 2020 09:35:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583847303; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=dpLWLg2+HhSfm+98QVG5YOZDb8h6SlYJ2Z1Wb0gwr4c=;
 b=iLUE75858ebM7fDg9PP3jTzbNx13yp9+j0PZE6Y4X3r0wYbt9sP18TYxCCXZkWvaFiMekIKp
 rj/rCg0CgweRJ2d9k7giBijZ/v4x/gD9Bo2rpXWL0SDXAXZ3rwB1rp8hmmM5aek8Dq5VGgaY
 dwXHI+8T9Uf2zaBG1ovmtJUFlVQ=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e67977d.7fa009517ab0-smtp-out-n05;
 Tue, 10 Mar 2020 13:34:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6913EC433CB; Tue, 10 Mar 2020 13:34:52 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 669F9C43636;
        Tue, 10 Mar 2020 13:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 669F9C43636
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] MAINTAINERS: update web URL for iwlwifi
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <iwlwifi.20200305142622.3b1f9018cd2e.Iccbce3e78befd4ac39735b26617cfb6a12a2ae5a@changeid>
References: <iwlwifi.20200305142622.3b1f9018cd2e.Iccbce3e78befd4ac39735b26617cfb6a12a2ae5a@changeid>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200310133452.6913EC433CB@smtp.codeaurora.org>
Date:   Tue, 10 Mar 2020 13:34:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> The current URL mentioned in iwlwifi's W entry is outdated and
> currently pointing to a dead link.  Change it so that it points to the
> correct Wiki page directly.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

da86cad0e011 MAINTAINERS: update web URL for iwlwifi

-- 
https://patchwork.kernel.org/patch/11421745/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
