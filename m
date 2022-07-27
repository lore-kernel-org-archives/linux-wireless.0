Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B49CC04A68
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jul 2022 10:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiG0K7S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Jul 2022 06:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiG0K7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jul 2022 06:59:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F0B48E99;
        Wed, 27 Jul 2022 03:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2596BB82015;
        Wed, 27 Jul 2022 10:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3167AC433C1;
        Wed, 27 Jul 2022 10:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919547;
        bh=vW6cSkOp4/7zf8XCInlICCJzylE/b2kproYiXL3qFgU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gvajeK0SXhi49E7yIicHLQ7y2JwRmU14BqpW0kd4XAV5OAhLWdTpoKNXaoSU7B148
         eB9kSqRbItteP055AvTlu0qTYwoQMjGv5+UAx5cBxE1oMJ2eU6QmCQL86e7moFh63G
         QfWxkmIANdlZCcLDfT4MRAGJ3exYdSAGdsUW1/wwdYVkj2QlWVFyPbxy6pwpWfcGXa
         bJNC1oONRzv7uWDWqOdfW2pfnswxOu6BXsqyfDoUumL0HVl4PRc0sjteexD3TdHa7r
         Eg6uqDF72gNhEe48k1Iqvd9rzY8amAC8jvn0xRBOvUEnCmGVLZNfV68FX/hRSJPGHf
         C9E80+VLGW8ug==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmsmac: Fix typo 'the the' in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722083031.74847-1-slark_xiao@163.com>
References: <20220722083031.74847-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891954346.17998.13709968594700541654.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:59:05 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Slark Xiao <slark_xiao@163.com> wrote:

> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Patch applied to wireless-next.git, thanks.

61afad44f9e9 wifi: mwifiex: Fix comment typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722083031.74847-1-slark_xiao@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

