Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233D4C56202
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 10:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C5A207DE
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 10:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKMKzP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 05:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKMKzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 05:55:14 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5946C0613D1;
        Fri, 13 Nov 2020 02:55:14 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kdWjV-006tti-Qb; Fri, 13 Nov 2020 11:55:09 +0100
Message-ID: <53474f83c4185caf2e7237f023cf0456afcc55cc.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX
 stats
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lev Stipakov <lstipakov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.ke, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lev Stipakov <lev@openvpn.net>
Date:   Fri, 13 Nov 2020 11:55:08 +0100
In-Reply-To: <20201113085804.115806-1-lev@openvpn.net> (sfid-20201113_095829_684007_366309B9)
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
         <20201113085804.115806-1-lev@openvpn.net>
         (sfid-20201113_095829_684007_366309B9)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2020-11-13 at 10:58 +0200, Lev Stipakov wrote:
> Commits
> 
>   d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add")
>   451b05f413d3f ("net: netdevice.h: sw_netstats_rx_add helper)
> 
> have added API to update net device per-cpu TX/RX stats.
> 
> Use core API instead of ieee80211_tx/rx_stats().
> 

This looks like a 1/3 but I only ever saw this, not the others.

Seems I should take this through my tree, any objections?


johannes

