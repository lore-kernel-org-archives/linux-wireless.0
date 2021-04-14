Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE134C433B4
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Apr 2021 07:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8070D613A9
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Apr 2021 07:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345147AbhDNHVG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Apr 2021 03:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbhDNHVF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Apr 2021 03:21:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42702C061574;
        Wed, 14 Apr 2021 00:20:44 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lWZpJ-00BVZM-7a; Wed, 14 Apr 2021 09:20:41 +0200
Message-ID: <4d0a27c465522ddd8d6ae1e552221c707ec05b22.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: indicate support for 60GHz channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net
Date:   Wed, 14 Apr 2021 09:20:39 +0200
In-Reply-To: <20210413010613.50128-1-ramonreisfontes@gmail.com> (sfid-20210413_030625_171185_B2224928)
References: <20210413010613.50128-1-ramonreisfontes@gmail.com>
         (sfid-20210413_030625_171185_B2224928)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2021-04-12 at 22:06 -0300, Ramon Fontes wrote:
> Advertise 60GHz channels to mac80211.

This is wrong. mac80211 doesn't support 60 GHz operation.

johannes

