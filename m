Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF10C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Apr 2022 12:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbiDAM3U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Apr 2022 08:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345876AbiDAM3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Apr 2022 08:29:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439DE27544D
        for <linux-wireless@vger.kernel.org>; Fri,  1 Apr 2022 05:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9CEDB824BE
        for <linux-wireless@vger.kernel.org>; Fri,  1 Apr 2022 12:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2227C2BBE4;
        Fri,  1 Apr 2022 12:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648816046;
        bh=aCZTUsF/0PKeVvVwFbUMsyGf0qGbd++bWrbiQzReW/k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ilBkEq+1zJD098HZ6PpSNciSBF+xQSTFwo0VvzPSMZsB5+ep43FCkpwleMQc5jpse
         lFFDt7NrjyISu7Wh5IjNC2YrIuqwCT8AHWrpYGbR5vucqh+lYhMvsw1C9ArmojZ6wP
         gWMtO5QHHGcUaeNMnlCuvc8R+kMSgdUzRGa9mTTtFgiNZU6d61C+KmsdfVOjK4VGzR
         wXjM9xvNaPUiUgjQ9Ao+lYNI7CSz1mls2NDtV+nEBtetWeElweXB/SDk1NeTnId6u9
         6U4BwZk3OGYOn4j91IBowiTQ1denmtXbrADjb1pUVTA71f/jxWqxMQpfyvFLZ6ZUxK
         12ED+veq5joaQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Baochen Qiang <quic_bqiang@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] ath11k: Add support for SAR
References: <20220401120948.1312956-1-quic_bqiang@quicinc.com>
Date:   Fri, 01 Apr 2022 15:27:18 +0300
In-Reply-To: <20220401120948.1312956-1-quic_bqiang@quicinc.com> (Baochen
        Qiang's message of "Fri, 1 Apr 2022 20:09:46 +0800")
Message-ID: <87sfqxt2e1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Baochen Qiang <quic_bqiang@quicinc.com> writes:

> This is to add support for SAR, currently it is only enabled
> for WCN6855.
>
> v4:
>  1. rebased on latest ath.git
>  2. add my own s-o-b in Wen'spatch
>
> v3:
>  1. rebased on latest ath.git
>  2. add Wen's patch to this patch set so that
>     there is no dependency.

Thanks, threading now is correct so I assume you run git send-email only
once.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
