Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A5AC77B76
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Apr 2023 12:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjDNMdO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Apr 2023 08:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDNMdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2023 08:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29321AF19;
        Fri, 14 Apr 2023 05:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF7C961FA3;
        Fri, 14 Apr 2023 12:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3919FC433EF;
        Fri, 14 Apr 2023 12:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681475586;
        bh=Y69wMnPQS9vYEGsWc6rHU3GfHiIE/Dgo33xdBBfWBQ0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Vew1os5awK/kNZH7RGwefay6icS6yRfzxH4BJLlyuKm7xLVIPDzRDTO2Kx8S/4bzi
         +Zm6v8hNYVnkBHY7KX1eLVg/lD9oZScQP2Kdo26bNysnCncVP+79XgJfVAKHlfwhG3
         uNHK7A7PzL8S61TSgxd2RNaPGGhXksInvZIAAwmqffARGsHQFknSrNUrpVNy0gQN1i
         dqNbjD8yThQSa+SNZ8vd5CGKXnhLwk+IPIZIWAdJYKLiPxP8hPR5QScaMfnNopUuwX
         NLHY2Gl+v5IYIkd9gKbBRkg2SCryo/jLedFj6+zz1VdIYKw+ti1/nIlmJ4d8guD4y/
         NlUu6NNeDomnA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] bcma: Add explicit of_device.h include
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230410232701.1561613-1-robh@kernel.org>
References: <20230410232701.1561613-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168147558198.16522.6525405237382366801.kvalo@kernel.org>
Date:   Fri, 14 Apr 2023 12:33:05 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rob Herring <robh@kernel.org> wrote:

> bcma/main.c uses of_dma_configure() which is declared in of_device.h.
> of_device.h gets implicitly included by of_platform.h, but that is going
> to be removed soon.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Patch applied to wireless-next.git, thanks.

666f4ab26c2c bcma: Add explicit of_device.h include

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230410232701.1561613-1-robh@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

