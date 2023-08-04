Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876F1C04A6A
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Aug 2023 07:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbjHDHFa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Aug 2023 03:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbjHDHF1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2023 03:05:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB4330EA
        for <linux-wireless@vger.kernel.org>; Fri,  4 Aug 2023 00:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97AE461F48
        for <linux-wireless@vger.kernel.org>; Fri,  4 Aug 2023 07:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36908C433C7;
        Fri,  4 Aug 2023 07:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691132723;
        bh=GkCPJcO9Eivz9/9/DX28RslwVuysp07c3XdplDhRmRA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FgjxIDz4osxd9RLMvDYJhvYXU2XBYjVy1rRDcAcsZvvsxZJ9NOuHrdlK29KmpnzB3
         dPjz5lB+ShYlgUDhT9rpkB4SXy6f1xwqRHwWloDLgo86EmX86QMhSF3DrHgctEiNVP
         P7dD6ChtZBtkXxRovIfgZJmsk0Kf+ZgC18dOTBSr64DecmO4AvdCe8SXSqJlZssnA+
         3hrk5vTH7ZYX7feWo7LiOrIoeupSrewNONR2y6RIqCMOOqiG6T7UlyUWO0NzR7xp2h
         USV7FBOaMqk37wPvqJ3DCRWjW26DI71tlXoJLpvmceOTOt24ZUe2Zy1DqnvAnscpzC
         AwbqL7OGLIJGg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ruan Jinjie <ruanjinjie@huawei.com>
Cc:     <toke@toke.dk>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -next] ath9k: Remove unnecessary ternary operators
References: <20230731124455.2039184-1-ruanjinjie@huawei.com>
        <fae803e7-9131-11bb-ad2d-7a61e76dc9ce@huawei.com>
Date:   Fri, 04 Aug 2023 10:05:19 +0300
In-Reply-To: <fae803e7-9131-11bb-ad2d-7a61e76dc9ce@huawei.com> (Ruan Jinjie's
        message of "Fri, 4 Aug 2023 09:19:22 +0800")
Message-ID: <87wmybs2xc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ruan Jinjie <ruanjinjie@huawei.com> writes:

> Ping.

Please don't top post. And also don't ping, you can check the patch
status from our patchwork. Read more from the wiki link below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
