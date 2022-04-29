Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363DDC433F5
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Apr 2022 19:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380223AbiD2TTb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Apr 2022 15:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbiD2TTa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Apr 2022 15:19:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D086B3BBD0
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2022 12:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83070B8377B
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2022 19:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE567C385A4;
        Fri, 29 Apr 2022 19:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651259768;
        bh=h8VQdzNDE7pccDYr4RYfg/BMn4apvx4uNZn+gypHhSU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iOO3sl2SVeReAhubw8VvA5D0/4fH3h/dmULB7F6HVSyYdsZPWRomgPlRRDm4s/oSS
         KqUUBQvMCV3REMfwzPHoXUgM6ZSTRtY/99Cbh5Wjc9ODCIuc0gHHdbecFgSCXCncdC
         qVAQ2ayncOWLwMYeDXYUJkioKMq3r9sfpM2CdkrjlhGs/aE6vVWjzZChtfpwjPaeBG
         oUmb6v04xvk5cvMHYj/prGpp1BjB5ZBHwpd6yhmpKlK3KeNQyzrJIDTa1LwLetXlsP
         dGj6WTD9jRPhHjTC4NdYfKxOB9Rq+IYq/nsAdWAtDsenfDdrYK96bQZOqlWhspxsMY
         ukvmsoUbgmnhQ==
Date:   Fri, 29 Apr 2022 12:16:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH wireless-next 2/3] wifi: ath10k: remove a copy of the
 NAPI_POLL_WEIGHT define
Message-ID: <20220429121606.74a22f91@kernel.org>
In-Reply-To: <87v8urd80j.fsf@kernel.org>
References: <20220429174643.196994-1-kuba@kernel.org>
        <20220429174643.196994-3-kuba@kernel.org>
        <87v8urd80j.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 29 Apr 2022 22:06:20 +0300 Kalle Valo wrote:
> This failed to build as recently usb.c got napi poll as well, I fixed it
> in the pending branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=89fc2e14d3e50cad605104572228d3740df7ca77

Sorry & thanks!
