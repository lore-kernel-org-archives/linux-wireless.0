Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427BAC433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  6 May 2022 06:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389386AbiEFGVD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 May 2022 02:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389384AbiEFGVB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 May 2022 02:21:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8925C361
        for <linux-wireless@vger.kernel.org>; Thu,  5 May 2022 23:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77A36B831EF
        for <linux-wireless@vger.kernel.org>; Fri,  6 May 2022 06:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEA4C385A8;
        Fri,  6 May 2022 06:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651817837;
        bh=R/IqYMA70GKlzEAbF0SXS9SWS5hXlUKXASu1VqBpxfw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=S1/tGnGQaxYrP0ra3aj+egoA0KODXIBEeBh+CXI7N2VXlS3CWQ0c5SfblPJhplgEm
         7a2GOUENT5KxbDAHMhRPyKLEY9JRbIKmwqySAxQ6f2SeO3oPsbid1HF+jKp2UZT2Ax
         CSr8IqvVlQaFHh7Hu87H9huxk9hUv/eUFCd62qfTUZ7xGTbMwBFbqTxJfhXULbaiW+
         w9Fy19H1ux2VHjebdLS2om4AyFWy4/PwG7cej77eANUyp3KYSE5D8sUXge+xMluwVM
         3bWER0avIVjoGCqRYUxacew8LpPU7U2TTwtaKv9aBDkwllJBfn080ebzh/5BTqpqc5
         UA37wTzk/T4vw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath11k: mac: fix too long line
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220503060415.24499-1-kvalo@kernel.org>
References: <20220503060415.24499-1-kvalo@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165181783347.13324.18042669600144341850.kvalo@kernel.org>
Date:   Fri,  6 May 2022 06:17:16 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> wrote:

> checkpatch warns:
> 
> drivers/net/wireless/ath/ath11k/mac.c:7760: line length of 91 exceeds 90 columns
> 
> This was introduced by commit 046d2e7c50e3 ("mac80211: prepare sta handling for
> MLO support").
> 
> Compile tested only.
> 
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

80c5075f3999 ath11k: mac: fix too long line
d9e441855c64 ath10k: mac: fix too long lines

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220503060415.24499-1-kvalo@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

