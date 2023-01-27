Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6020C61D97
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Jan 2023 07:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjA0HfH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Jan 2023 02:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjA0HfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2023 02:35:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F087816332;
        Thu, 26 Jan 2023 23:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A73619B5;
        Fri, 27 Jan 2023 07:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7235BC433EF;
        Fri, 27 Jan 2023 07:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804905;
        bh=70plA/u/jZ1FXvVzCBcMxvArW3LDXt8FKc9u4FfzeTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mjrUiFDEhSSm6WnLsbbOFlsBXUe5PkjgkqHD/+VLjkB1U6XUglWWxPZsAOvWZv2rt
         sw3VTPQtAZ1y+ew+a+qme5Hu6M1d6ojLRuSEPR2QfWCG1D7ZKMG35+Oe2hJtvTzlzv
         jqtqbd2WzZirahnNJw+YlH/aES82j3+KLiwX5Jmo=
Date:   Fri, 27 Jan 2023 08:35:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 0/1] mt76: move mt76_init_tx_queue in common code
Message-ID: <Y9N+ptDV4QKj8h2C@kroah.com>
References: <20230112115850.9208-2-n.zhandarovich@fintech.ru>
 <20230122155910.32635-1-n.zhandarovich@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122155910.32635-1-n.zhandarovich@fintech.ru>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Jan 22, 2023 at 07:59:10AM -0800, Nikita Zhandarovich wrote:
> My apologies, I should've have explained my reasoning for the patch better (and sooner).

I'm sorry, but I have no context here at all.  Always properly quote the
email you are referring to.  Remember, some of us get 1000+ emails a day
and can't remember anything we wrote in response an hour later, let
alone days or weeks.

confused,

greg k-h
