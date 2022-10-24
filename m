Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BDEC38A2D
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Oct 2022 10:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJXK6h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Oct 2022 06:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJXK5h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2022 06:57:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438C058DE5;
        Mon, 24 Oct 2022 03:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50A3AB81042;
        Mon, 24 Oct 2022 10:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6E2C433D7;
        Mon, 24 Oct 2022 10:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666609043;
        bh=4bSLcRGH7XdHy44vHkbsiLOtkgbfXoOzFMbGbFf8Wt4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bep0KqiW9Vjj2+ldrhYUiSFBTdsLvuOF9bsiP37UqxtFYWTFVri36t3j7MA0DFr3Y
         bIHvtzq4t+WAB4j03ixo80aQ5lv0E4eI1hK9ghT1IXBWvu6M76mv4bIHt37du+tJG3
         fJzY+T5BPz8hPbNq9Lor3yfUbGocMK4xvmLUj0okia0QXC73TeqQ73hwwuewEwI12H
         3lDiQ/x8yJ+ExVcc8qAXt4VykNZu8bUsncl27JDGydu7lLHocwrfVcMOVXGhu2Ruw3
         n7HSDrqJMvTFRt5uY6pLBA3GR5rrky49OEJmVIJguGL+2W3irms3KOhxvZaGFE2OQ0
         Gs+Kej6UOUTfg==
From:   Kalle Valo <kvalo@kernel.org>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     gregory.greenman@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        inux-kernel@vger.kernel.org
Subject: Re: [PATCH] fw/api: fix repeated words in comments
References: <20221022054100.30299-1-wangjianli@cdjrlc.com>
Date:   Mon, 24 Oct 2022 13:57:19 +0300
In-Reply-To: <20221022054100.30299-1-wangjianli@cdjrlc.com> (wangjianli's
        message of "Sat, 22 Oct 2022 13:41:00 +0800")
Message-ID: <8735bdij5c.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

wangjianli <wangjianli@cdjrlc.com> writes:

> Delete the redundant word 'the'.
>
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It's easier if you fold this patch with the first iwlwifi patch.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
