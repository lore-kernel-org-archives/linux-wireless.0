Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AA0C04A68
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jul 2022 10:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiG0K7y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Jul 2022 06:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiG0K7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jul 2022 06:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F2648EB3;
        Wed, 27 Jul 2022 03:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06215618B0;
        Wed, 27 Jul 2022 10:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC7EC433D6;
        Wed, 27 Jul 2022 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919583;
        bh=NOf+i5b0V5kj2gY1TJAm6ix8SLfEutiO/HMAUH9vsT0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Tx+WlyRGkKOUZnNsFwqrp+FbMmR/M3t5wxcAdHoJqYiL0POSRCScaO6zKlRHkTClp
         NVmqQMJge1lJM2CDDJ5LOn4MtYOvGUXEsft3smWC98RJWlKmFbCBIZ7V0u8wz54lf/
         rBAe6ISQzEMFW2+YWRYiNzDrA7JBP3YIeMjwpU5AwGUBmuv9RiW1j1nMxb42l+wnkx
         WzP1H5jzm5OyTihFgf8v0RcggjfJ15cL8JBCyU1nnHI00Ahfy/+yFkwsm1PbrHczxH
         XbmHxs3eHbSi14sUS7pY/4rQ8ehU47HyvEi9N7astW4iY36oXm0nIs+tzO7p6j7SH4
         jktCndQaYVsNQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: wl1251: Fix typo 'the the' in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722084833.76159-1-slark_xiao@163.com>
References: <20220722084833.76159-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891957995.17998.769866736095602356.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:59:41 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Slark Xiao <slark_xiao@163.com> wrote:

> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Patch applied to wireless-next.git, thanks.

08df8fbeb241 wifi: mwifiex: Fix comment typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722084833.76159-1-slark_xiao@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

