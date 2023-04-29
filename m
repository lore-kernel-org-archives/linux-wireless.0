Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0BDC7618E
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Apr 2023 05:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjD2FVA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Apr 2023 01:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjD2FU7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2023 01:20:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17D11FCF
        for <linux-wireless@vger.kernel.org>; Fri, 28 Apr 2023 22:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78CFD61022
        for <linux-wireless@vger.kernel.org>; Sat, 29 Apr 2023 05:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3B3C433EF;
        Sat, 29 Apr 2023 05:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682745656;
        bh=+Ce7hsewW9AaYw3BQ3lTmmyLJmdmL+YYQKZgd9ohDxI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fAPVZFB50UdQPVhMxkmpNWxzcDwRvT1z8xV6XCBgiE1FjPyQKrmhyDjoS+2ul2F8X
         EsDqK5fo2Id2dcEV9JAYeGSn59QApCyI7u4p9NOpL5OgRTjBrey20zI/T5ZK7xJnE4
         jJ6x1WiJtD1DTCv39kPPL5oz4bH/xEPiNpZFXfOOEWKBYDDiHrEZa6A6lTyLpM4Gff
         r2eR+0Ch/0/flS/sn9tiWWsgsiusnSa4UZ5RS+hyoXjNDnwb46r4JPnmo0k9j+Kzxa
         +0EStmgA6mj4kOXQodsc7QOTiLWGQDVQ2ycqn2WFE7vOuJkafN6HRjqmiEbzLyhFHG
         Xgyacu8/8+dRA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: rtlwifi: rtl8192cu: Remove driver
References: <20230428182933.19157-1-Larry.Finger@lwfinger.net>
Date:   Sat, 29 Apr 2023 08:20:54 +0300
In-Reply-To: <20230428182933.19157-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Fri, 28 Apr 2023 13:29:32 -0500")
Message-ID: <87pm7nqn61.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> The functionality of these devices has been replaced by the rtl8xxxu
> driver, thus the version under rtlwifi can be removed.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Should I take this to wireless tree for v6.4?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
