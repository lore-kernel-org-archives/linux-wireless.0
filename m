Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B230C433F5
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Feb 2022 09:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347280AbiBUJGL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Feb 2022 04:06:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347532AbiBUJFv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Feb 2022 04:05:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377E72E0BE;
        Mon, 21 Feb 2022 00:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E4061132;
        Mon, 21 Feb 2022 08:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F37C340EB;
        Mon, 21 Feb 2022 08:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645433954;
        bh=JSSkz6JDVVsI+47zV8Q+XVfwTHl1baGUJpcfSdWbuDI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HeIHqQIFKHM8049vKx1LZN3kU75xJmSqSydqHLqGgLhyg+Wl5RvXHNVcYooalkSRM
         ouTYDPiXpwUmTCw4zGrocSKK4lWPcTAV43k6n3pr8mfUzJmLpUgIFw+bJLr+evF+5n
         fvfm0XfCVBiC0bmVcLjO9zz7Is9dK8l47FFykORu+3NRKPcBSuZnHVupxCTVFzOT20
         OqTREa5Vh2nOkdZi++CM9ScSCKJZaSo5UnXdfvMKZ7wujtiicfHuVYnhegf5T/GVph
         oOc9ijmQq4O60zuvAhLxf4dHXpz8gN4oqTfas/0JdELudZQZxPKH64ykIIGMmnY/Jq
         mzGLiedH5EfMw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] bcma: cleanup comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220213213121.2806376-1-trix@redhat.com>
References: <20220213213121.2806376-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164543395140.995.4969921180404525569.kvalo@kernel.org>
Date:   Mon, 21 Feb 2022 08:59:13 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> Remove the second 'info'.
> Replacements
> 'adventages' with 'advantages'
> 'strenth' with 'strength'
> 'atleast' with 'at least'
> 'thr'u'' with 'through'
> 'capabilty' with 'capability'
> 'controll' with 'control'
> 'ourself' with 'ourselves'
> 'noone' with 'no one'
> 'cores' to 'core's' and 'core'
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Patch applied to wireless-next.git, thanks.

032931fdd53b bcma: cleanup comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220213213121.2806376-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

