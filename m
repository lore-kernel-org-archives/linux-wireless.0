Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80730ECAAD1
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Sep 2022 10:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiIAKfw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Sep 2022 06:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiIAKfu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2022 06:35:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682456B143
        for <linux-wireless@vger.kernel.org>; Thu,  1 Sep 2022 03:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D67E61CF4
        for <linux-wireless@vger.kernel.org>; Thu,  1 Sep 2022 10:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CFEC433D7;
        Thu,  1 Sep 2022 10:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662028548;
        bh=O1C28Qan7lecYQNW4DGZCbFSscmkaV+XH1L6u/xI/UU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mxYZ/TZZvZOKY7jxVSYzf0rL/hw08hWCc7QqHuTk+AJ51K/3iHv1Fn/CcatbwnzMB
         a5D+kn5baBXcVIjh14A/rNfEwZi5FlxouuOOUvsqETBR1Y8WNsOjvgbIxDUepPWyMh
         Z2zDqHBOQds5qh/1e7bUNdtDuV7IYqfjONJ6CkQCAKxPj2YQSmEy4GlRGXRzgTTDXX
         j+Qw26DDT25dDoAwD5qYQKGB0P0g0fPmzO1mwLqciiGzMdWhGzLXlCCs1amvBzQ06M
         3yzp+zKP33DQnCzJJJ+fW7EOLVJx+gYTgYiisPuOFfE/Yz0jjDplUDEohe/wR4EgQD
         adNH6c/LAjAAw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Vasanthakumar <quic_vthiagar@quicinc.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] wifi: mac80211:  extend rx API with link_id for MLO connection
References: <20220817104213.2531-1-quic_vthiagar@quicinc.com>
Date:   Thu, 01 Sep 2022 13:35:45 +0300
In-Reply-To: <20220817104213.2531-1-quic_vthiagar@quicinc.com>
        (Vasanthakumar's message of "Wed, 17 Aug 2022 16:12:11 +0530")
Message-ID: <87mtbje60u.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Vasanthakumar <quic_vthiagar@quicinc.com> writes:

> From: Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>

Your last name is missing from SMTP From header:

From:   Vasanthakumar <quic_vthiagar@quicinc.com>

If you fix that git doesn't need to add a second From header to the mail
body.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
