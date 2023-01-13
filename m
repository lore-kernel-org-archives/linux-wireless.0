Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C019C678D4
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Jan 2023 19:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjAMThb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Jan 2023 14:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjAMThH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2023 14:37:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DE789BC0;
        Fri, 13 Jan 2023 11:33:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2E8BB821CC;
        Fri, 13 Jan 2023 19:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55673C433EF;
        Fri, 13 Jan 2023 19:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638418;
        bh=ojpKOOeOrwJgOO034G1NDRHZRYt0VME1XPFmRQj4nT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gT2hXurENLuMhIjwM/8tUl1mg5gYVhMMSFWTaHiplNKGkXZglSbhpuQqWoke1Cuzz
         5VqMfCoRw8slNRqGnKt2crhTLTuJW58Fq33rQ4OydLesDo+O7skekS7y+0+BUfOfn2
         z8leCAUcC1ttsN132G74DTM9KGXmyKjFWKSn+XBxjEaJXTFYL5PHChFaq/W1Nndf7m
         0KoPymcezsaKW/hP5mknJaZM7lovBGMGTrDw1Mf1wOe44Z1iqondaG+2bqZ1lR/UJc
         NrqmBBWTvezAKuv5YW7RfmEp9vDsvwKwPAQwqidCOmBh74bw2KQ3URTKKKuXdsZdr0
         d7r+o3SbQr2dg==
Date:   Fri, 13 Jan 2023 11:33:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-2023-01-12
Message-ID: <20230113113337.2ba6390c@kernel.org>
In-Reply-To: <20230112111941.82408-1-johannes@sipsolutions.net>
References: <20230112111941.82408-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 12 Jan 2023 12:19:40 +0100 Johannes Berg wrote:
> Please pull and let me know if there's any problem.

Pulled, thanks!
