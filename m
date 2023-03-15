Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B645C6FD1D
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Mar 2023 10:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjCOKQB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Mar 2023 06:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjCOKQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2023 06:16:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440394C6C9;
        Wed, 15 Mar 2023 03:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D235B81DC2;
        Wed, 15 Mar 2023 10:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADCEC433EF;
        Wed, 15 Mar 2023 10:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678875301;
        bh=ayiZu6co1Nt0oF8/9K2DyHZxjmr6VDHH0+zwgOu2Gs4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=g08dBd0S1ztIYGmKAPI86fz/y8r1lcjRRqYaAjMSmG7MhUkhFVWMzNTiD42N7sGaJ
         F7eb6/cpEF76NGuZZ/SqURqsAbbAmHOk0JBE8iKARUd1EcnS5muAIKgy9OcTGpbrC7
         T1c5cTzVnCxjRzfXzjnN4y9Tbi7iH6hRNYzTGe/bs/VNKb75EAuumL8xhrvMYVkcP1
         W/t3Dg2L12kMKzDqdmHHBqf+dMbeQglu+UeZbt4ROPZ6qfqeDItavKQXG9miTmOIQe
         2eRiNMurChJqZVYP1is0WWJ6sYMjKH8kfU1GTLB39j0b0b5VjbRMPb61YWZ96mEz0M
         HT+6496A6Pt9w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230306125041.2221-1-bage@debian.org>
References: <20230306125041.2221-1-bage@debian.org>
To:     Bastian Germann <bage@debian.org>
Cc:     toke@toke.dk, Bastian Germann <bage@debian.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167887529700.21988.13525749000670884909.kvalo@kernel.org>
Date:   Wed, 15 Mar 2023 10:14:59 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bastian Germann <bage@debian.org> wrote:

> The USB device 1668:1200 is Qwest/Actiontec 802AIN which is also
> correctly claimed to be supported by carl9170.
> 
> Supposedly, the successor 802AIN2 has an ath9k compatible chip
> whose USB ID (unknown) could be inserted instead.
> 
> Drop the ID from the wrong driver. I happened to find this by chance while
> packaging the ath9k and carl9170 firmware for Debian.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

f94d7a3a5107 wifi: ath9k: Remove Qwest/Actiontec 802AIN ID

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230306125041.2221-1-bage@debian.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

