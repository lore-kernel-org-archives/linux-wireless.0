Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2962C6FA82
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Sep 2022 06:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIVGJK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Sep 2022 02:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIVGJK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2022 02:09:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD25B4EB8
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2022 23:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 382F16288A
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2022 06:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46FDC433D7;
        Thu, 22 Sep 2022 06:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663826948;
        bh=x/iCfQzPAXDIwUoPt0mQ5jkrG6NVdWzzEv34BR4dyZg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CDJTKYo7iMXfpV/z5lZkjD+xvvtZCvUC/RqVnaPMJXSGnK2bcv+1g4RwVfzL+ouGv
         rZfsy9I2QH/C67Od6rOoR+myHzJrZ4TAm7AKX/rE8X77+J4gmMmqyhSGVtvX8R9ntV
         W8OzriOFz2OLOSNn7I3GdUY8r26bHnVPlYTA5xJ5eAgvGgqcL+XOHWVDN/hL4Usy6E
         D4RpSDUH7H2Tx4QSguJpYxrHGsnNGy8Xb2vnOP5V4TyTi1MBl4H9eoDPW3NynTWoXs
         XJ23sOXN7DJjaKujKqmJSyi7Z5X/c4e/qb7HqtWsJ2TwpLsBBzUlHE7iTes0aVZut1
         bgq8PH0cU0A0w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/12] wifi: ipw2x00: fix array of flexible structures
 warnings
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220904212910.645346411660.I471e8fadce54ea262920828f25b8e84545bcd07e@changeid>
References: <20220904212910.645346411660.I471e8fadce54ea262920828f25b8e84545bcd07e@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166382694569.9021.3076206794710420639.kvalo@kernel.org>
Date:   Thu, 22 Sep 2022 06:09:07 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are a number of these here, fix them by using
> appropriate casts. No binary changes.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

3 patches applied to wireless-next.git, thanks.

28255dd9a8de wifi: ipw2x00: fix array of flexible structures warnings
c70a9d6783cf wifi: rndis_wlan: fix array of flexible structures warning
4cf4cf6eb0bf wifi: mwifiex: fix array of flexible structures warnings

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220904212910.645346411660.I471e8fadce54ea262920828f25b8e84545bcd07e@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

