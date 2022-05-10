Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEEFC433EF
	for <linux-wireless@archiver.kernel.org>; Tue, 10 May 2022 16:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243641AbiEJQg6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 May 2022 12:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347446AbiEJQgx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 May 2022 12:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB41205276
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2022 09:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35D8BB81E1B
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2022 16:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19842C385C2;
        Tue, 10 May 2022 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652200372;
        bh=rZy3xFI95sRmdsbmw9vXIg7pgZGWE7uVQM/i87TmZd4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=vNDzXxoPyqWLh/OCq/Y/MqSyu5OYJL+6Z2LF2azjhjKXoClt+KEY4lvH3SpumAKyk
         wXcXltmt6JdewYQeByek1pEzhDtUc3CyYQSpuXTm0HdbWJmoZf0+DZPY0QVfGf6k5E
         3122kQSj6wCRrDFgKtdfljujc84lytg5OU02/faR4eUuBQyAREZcTjnoiFuE0J8D8u
         +GHNNuvbpSVNT8D2/jZLIrUpSE9ZbFbEyqqC3oMPDnJQbhKCL9it0iwwtWicRXdUMa
         3/L1I9BY2mdffEU8Yi52/hNZf7QvGct8R5aeGVDQKNAS91I+iMTJexU0ZjHGhyuBDX
         ZMYa2TmQE0Xig==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: remove 'freq' debugfs
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220506095451.9852305a92c8.I05155824a1b9059eb59beccde81786dc69de354a@changeid>
References: <20220506095451.9852305a92c8.I05155824a1b9059eb59beccde81786dc69de354a@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165220036989.6768.11723448794392191911.kvalo@kernel.org>
Date:   Tue, 10 May 2022 16:32:51 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

> This is completely racy, remove it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

4255a07a98cb wil6210: remove 'freq' debugfs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220506095451.9852305a92c8.I05155824a1b9059eb59beccde81786dc69de354a@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

