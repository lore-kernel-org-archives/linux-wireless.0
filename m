Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EACDC433F5
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Apr 2022 07:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiDFHb7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Apr 2022 03:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238416AbiDFG4H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Apr 2022 02:56:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A15A1DB7F2;
        Tue,  5 Apr 2022 22:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E5FB619EC;
        Wed,  6 Apr 2022 05:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241FFC385A1;
        Wed,  6 Apr 2022 05:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649222643;
        bh=Mul9AJ93AVH0Pdg7HmZn/H/9BvyBCq6o30Igx61Upxc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Am9WcrfAlbrARvfo6v8rQN4UAAli/FBiMCG+pmwkxJptd2owz3q1KXTJPyBgU39lA
         7mUSWKzmubvs+ZYaqqJeY7YyJnnoRm5OUBR8T+XSZkqS3vVAW6ZadxLfR3Gx/Rot6G
         Gem374uz50GhTPFu4tKwjWFTO/Uu8YZ3Rkn7yyb52BzmV9S/JWldfGNTROeWljkDo0
         bRcGpI1q/2a88MJU1I+FrOTzckRVIVrz9Lj0VQF3qylc/3zUKLzlLCv5NkBYKQotC9
         2gq8lHuWs21rJdzTBerVR20PgxP5AOOfXFZU74E9ZUD1W5QB6aG0iPywAo/OP5AX3+
         BS7crmsY4SsdQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ipw2x00: use DEVICE_ATTR_*() macro
References: <20220406015444.14408-1-tangmeng@uniontech.com>
Date:   Wed, 06 Apr 2022 08:23:57 +0300
In-Reply-To: <20220406015444.14408-1-tangmeng@uniontech.com> (Meng Tang's
        message of "Wed, 6 Apr 2022 09:54:44 +0800")
Message-ID: <87y20iss2a.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Meng Tang <tangmeng@uniontech.com> writes:

> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
>
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>

ipw2x00 patches go to wireless trees, I think for this patch
wireless-next is more approriate than wireless. No need to resend
because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
