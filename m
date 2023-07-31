Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5FCC001DF
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Jul 2023 09:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjGaJrL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 Jul 2023 05:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjGaJqn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2023 05:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0C610D9
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2023 02:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF06960FDF
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2023 09:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31931C433C8;
        Mon, 31 Jul 2023 09:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690796766;
        bh=f3itKI7tUclmzgaUBhe9sHiul4ApNE2O4C6yzfSNKjg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JaBrtbdwfle7Hzuc/QiXWP8hrUjEylYOtqcOioZxMzVP6QnvF/rbCbAoXVs5GeMKl
         3zU5dXL1oQv9+JzXRUP6TGoH6p6gJl5xYo6bJ6gOhxScsb1qzdCU+EwkS9OwBw+T0q
         LJ/xqd44XVIXtZS96zj+2uRHPuKUU8XcddPZmgdtkq86TeL4+qmVzXz/RPMNZz8Avc
         /8dAItOSXRrGDAtIOgK3cc23JBSi5+XJpFgozjb1kc5U/UfIce+w2puhS5vuxPcH5f
         gsrzU+vIWUK6aAKS0Er/O8O6LFmxP3rr7OuFk+X/6XmIS8fKEJSisKGOgdFvBjtNvr
         vs11v1/Bie9qA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH 1/5] [v2] wifi: mwifiex: fix memory leak in
 mwifiex_histogram_read()
References: <ZMFzBStAKemf+dLL@google.com>
        <20230728084407.101930-1-dmantipov@yandex.ru>
Date:   Mon, 31 Jul 2023 12:46:02 +0300
In-Reply-To: <20230728084407.101930-1-dmantipov@yandex.ru> (Dmitry Antipov's
        message of "Fri, 28 Jul 2023 11:43:42 +0300")
Message-ID: <87cz08za5h.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> writes:

> v2: adjust to match series

I don't know what that means. Please try to be specific in the changelog
entries. Also it might be easier for you if you include a cover letter
and place the changelog there.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
