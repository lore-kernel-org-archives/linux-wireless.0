Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE48C433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Mar 2022 05:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbiC1Fa2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Mar 2022 01:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiC1FaZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Mar 2022 01:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFE2E032
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2022 22:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2115DB80E02
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2022 05:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CE8C004DD;
        Mon, 28 Mar 2022 05:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648445321;
        bh=qXT1RYdRQWNvWIkjhT87RVxW12795qxkxnxn8PZSQfs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aqK1klfmvho6ViPfpW1Cc+uiQIndShUr0QP79ovz5SbKaYm0dolznTLIo0TGZumV5
         5t4PIu2PBHsFP9H54YQDvmgrgjiMt/3h0rkCiPl/ADZnqOo/qUwfQTHnb8S0u0Ly1S
         czGdH7hJMQCQa1iaBDXB7sWF+CSK/57lR5m1mQtuBkQlXcMR95tNO56KmLkIUFKRPz
         6B8SMEmLtMreWXWYbcbPLkX9M1aC/U4u0drR6RtUcOkm2sAAbVMNAFIREInauod42q
         WMjhUEHXBO955mjN5eXVstT7aLbMu4SsuT48d+lO6QYHchdD2VkP13i+yw41b73KW3
         gfLcLrtlZyLoQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH 1/2] ath10k: add support for MSDU IDs for USB devices
References: <20220327171340.7893-1-erik.stromdahl@gmail.com>
Date:   Mon, 28 Mar 2022 08:28:34 +0300
In-Reply-To: <20220327171340.7893-1-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 27 Mar 2022 19:13:39 +0200")
Message-ID: <875yny1w8t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> commit 93bbdec6683e1c8ba2cc4e6 ("ath10k: htt: support MSDU ids with
> SDIO") introduced MSDU ID allocation in the htt TX path for high latency
> devices. This feature needs to be enabled for USB as well in order to
> have a functional TX path.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

On what hardware and firmware version did you test these patches? I'll
then add the Tested-on tag:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#tested-on_tag

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
