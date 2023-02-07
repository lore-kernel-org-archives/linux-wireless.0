Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF2CC636CD
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Feb 2023 09:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjBGJG2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 Feb 2023 04:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjBGJG1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2023 04:06:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898AD360B3;
        Tue,  7 Feb 2023 01:06:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E4161221;
        Tue,  7 Feb 2023 09:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC0EC433EF;
        Tue,  7 Feb 2023 09:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675760785;
        bh=LC30KfNMP47HOviSbfEBMNfX4DyP4oqLUNUeOuxsdk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2i1KEWrJzTtSD/FOEZj+zS0OxEgxGjuYQEgsuvxVqFuu3eS4WjkRv95WjxoQi20tr
         /1gk4QwgSgLa85dBvvKlPUi85eKi6JrYHzw69RU2672JlT6GReac+U8w/83us0XkSM
         G2RsNt6BEPuSTwnKAL6cNKW98davkPp0WlDsZN78=
Date:   Tue, 7 Feb 2023 10:06:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v7 0/4] mac80211_hwsim: Add PMSR support
Message-ID: <Y+IUiSBO08h7Fo+f@kroah.com>
References: <20230207085400.2232544-1-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207085400.2232544-1-jaewan@google.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 07, 2023 at 08:53:56AM +0000, Jaewan Kim wrote:
> Dear Kernel maintainers,
> 
> First of all, thank you for spending your precious time for reviewing
> my changes, and also sorry for my mistakes in previous patchsets.
> 
> Let me propose series of CLs for adding PMSR support in the mac80211_hwsim.

Again, what does the term "CL" mean?  I have not seen that used for
kernel patches before.

thanks,

greg k-h
