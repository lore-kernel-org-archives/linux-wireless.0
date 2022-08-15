Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F377C00140
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Aug 2022 06:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiHOG3F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Aug 2022 02:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiHOG3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Aug 2022 02:29:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386C01A070;
        Sun, 14 Aug 2022 23:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0AD4B80B8D;
        Mon, 15 Aug 2022 06:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB7CC433D6;
        Mon, 15 Aug 2022 06:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660544940;
        bh=msiJ57i3RqcfN26mM82wBD0lWh7NBADgC1IhxLozSbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZkmSRmrGWmBg1v/nvxcseOia4EwffJWALIvgjZQWXxz8IQ6lc+KpgyxzKKR1CKCF+
         +y9YlGQ34Zzrl0fZAIhDveNEcLNdedPyjSzcljRrzz+ooOW9mOPXp6xSsOcQo342XY
         lUw94NwSBuVTYWVMaJVMTObfj+XIQc+vn/sRT9r8=
Date:   Mon, 15 Aug 2022 08:28:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     phil@philpotter.co.uk, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: r8188eu: Prevent infinite loop
Message-ID: <YvnnqDwLUEiDVfs3@kroah.com>
References: <20220814174404.25923-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814174404.25923-1-Larry.Finger@lwfinger.net>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Aug 14, 2022 at 12:44:04PM -0500, Larry Finger wrote:
> ---
>  drivers/staging/r8188eu/core/rtw_ieee80211.c | 3 +++
>  1 file changed, 3 insertions(+)

No changelog or signed-off-by?

:(
