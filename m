Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465FFECAAD3
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Sep 2022 10:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiISKCu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Sep 2022 06:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiISKCu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2022 06:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4F822BC6
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2022 03:02:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07FBF6115B
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2022 10:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34D4C433C1;
        Mon, 19 Sep 2022 10:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663581768;
        bh=WiKNcnnd4gBhbWbiRrELLQdXctaEsPnw2VBpF/Av6jM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gjkgzef8bG5ZBTEWqkyLU3bvKwADkm7LIUNXNfe46olai1JsfIZ5ZmSo/v0WGXV38
         U9S+dONAYvEVSgPNEQRNOYcpTnjBD5fDf7NUCEYf9rPdwDK3+ohO9brGAbv5D07joo
         6a6rrT757Mx6FQwwOyGKikx4OAYs5cDjafmSzdUoaVM+BjoGVfrmgrrMJygVzU2KLR
         2ouUVcwqIuZ8OffHxFOkz1Tzti78KQN1Z8zgQuvHSWdPVNYMH7nxKo8X/9CB9QrgZI
         uSywoYp8g5bCVVznzTtdzQcfb0lWS/8rvTLF8Fb9lHuVetDrzR/BW2CEyLx/y1058l
         5Ith2u//wH+hA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] wifi: rtw89: support for setting HE GI and LTF
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220912070014.10018-2-pkshih@realtek.com>
References: <20220912070014.10018-2-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <damon.chen@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166358176556.24821.8904229002377977592.kvalo@kernel.org>
Date:   Mon, 19 Sep 2022 10:02:47 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Kuan-Chung Chen <damon.chen@realtek.com>
> 
> Support setting HE GI and LTF values to the kernel via nl80211.
> We currently only support some GI and LTF values settings.
> 
> The command example is:
>   iw wlan0 set bitrates he-gi-2.4 0.8 he-ltf-2.4 2
> 
> Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

2 patches applied to wireless-next.git, thanks.

0891b366cef4 wifi: rtw89: support for setting HE GI and LTF
3004a0a44559 wifi: rtw89: support for setting TID specific configuration

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220912070014.10018-2-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

