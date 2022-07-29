Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5315C00144
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Jul 2022 13:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbiG2Nb2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiG2Nb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jul 2022 09:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711FF57205
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2022 06:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F7F4B818D2
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2022 13:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7A8C433C1;
        Fri, 29 Jul 2022 13:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659101483;
        bh=3GrdIhcL94pnIe+H1ScbAnzW6WinPEgol09V60ooZx4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ALHCdupZYIeGqmHo7XjdoAjJODPjND3RUX6ooW+rWGnpQLqq88wINr0s8+mJafZKU
         t9dkQS4lrKBb2yobd3SDuxshLLMJpW2/lQp8+o3hp162c4XVGcaRlBSD8O64YsRxXF
         VTUcrG0r2McX0c/ufVxeDnB8fxjL7/dJPCwBjkXtN20vCDHpu2tFN/eMtLCkT5c6li
         DnNt1slLHLlfqC85hFaxSNwWi3mYN4llot923NfA+uWBz+uku3HkLNHg+433GWSMgN
         kv2sXPQSo2WJDyZIZEOF+/5NTC3wiNLLDfNx0YpEcMyKB9IevIz7Zao8k37xTIVGyp
         SCU/H5hCyE2KQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: 8192de: correct checking of IQK reload
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220727083306.32689-1-pkshih@realtek.com>
References: <20220727083306.32689-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165910147835.2014.2743547611015368428.kvalo@kernel.org>
Date:   Fri, 29 Jul 2022 13:31:23 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> This mistake is found by commit ee3db469dd31
> ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12"), so
> I recall the vendor driver to find fix and apply the correctness.
> 
> Fixes: 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Sorry, I just don't understand the commit log. Can you try to improve it,
please? Especially describe in detail the bug you are fixing.

Also remember to use "wifi:".

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220727083306.32689-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

