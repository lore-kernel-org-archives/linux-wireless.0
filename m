Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA42C38145
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Sep 2022 08:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiIGIEL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Sep 2022 04:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiIGIDd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2022 04:03:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BB5A9C0B
        for <linux-wireless@vger.kernel.org>; Wed,  7 Sep 2022 01:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3EB7B81B89
        for <linux-wireless@vger.kernel.org>; Wed,  7 Sep 2022 08:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6FDC433D7;
        Wed,  7 Sep 2022 08:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537809;
        bh=8S2vraaX/gh9uu3+DVyaqg/qW7Bvi8JSPuvc84WBIvk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=p+6WW1tRyaCES9iKq/HsMitqEPt4W1SL8QwMeqeyKMu4gMKo3ZAyvsVyvfGhfCA5/
         mtqjplhR25hpv/GRqQGoz9VtZrHWzUHp827+roAdm3YWPsPsI6i0vYBB8345rQwRnB
         G3nAv+p+6TEAeYLVFR60a2B7kQv8/H/6XxL1zwRHDlaGP8/cSxcQx+hFSOG7iXPWTQ
         ikxbZfEyinKHtzlHK4n7az3XxkXdMJScHI7qrid7uhmdKz2JMy2TzydyVhwJDvSmIX
         KoxHBmBa2LDcvCv61IE0eea4uu0B1gUnhavSh5g/kKACY8Nfs0lk+ZyytFClJYWZHp
         8flwMVBlVbaxA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/12] wifi: ipw2100: fix warnings about non-kernel-doc
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220904212910.8169e8c9090c.I0357e80cc86be2d4ac6205d1f53568444dcf7c9b@changeid>
References: <20220904212910.8169e8c9090c.I0357e80cc86be2d4ac6205d1f53568444dcf7c9b@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253780670.23292.13882069969367028497.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 08:03:28 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Just remove the extra asterisk to make it not be
> kernel-doc formatted.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

9 patches applied to wireless-next.git, thanks.

76a8c54c53d8 wifi: ipw2100: fix warnings about non-kernel-doc
a08e3518bf45 wifi: libertas: fix a couple of sparse warnings
9d5b665775d6 wifi: wl18xx: add some missing endian conversions
3208ae450248 wifi: mwifiex: mark a variable unused
e1ff3b48996a wifi: mwifiex: fix endian conversion
fbe7e18581ef wifi: mwifiex: fix endian annotations in casts
df8e1af22cee wifi: cw1200: remove RCU STA pointer handling in TX
53b17c121f29 wifi: cw1200: use get_unaligned_le64()
8f15a8d6786c wifi: b43: remove empty switch statement

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220904212910.8169e8c9090c.I0357e80cc86be2d4ac6205d1f53568444dcf7c9b@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

