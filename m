Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B227C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43A6D206BB
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfBVM0p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:26:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:37504 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVM0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 07:26:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gx9ub-0002fi-So; Fri, 22 Feb 2019 13:26:41 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mac80211_hwsim::: propagate genlmsg_reply return code
From:   Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1550553160-18324-1-git-send-email-lirongqing@baidu.com>
References: <1550553160-18324-1-git-send-email-lirongqing@baidu.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.15
Message-ID: <E1gx9ub-0002fi-So@sipsolutions.net>
Date:   Fri, 22 Feb 2019 07:26:45 -0500
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Li RongQing <lirongqing@baidu.com> wrote:

> genlmsg_reply can fail, so propagate its return code
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Patch applied to wireless.git, thanks.

b97c9cb91d51 (HEAD -> mac80211) mac80211_hwsim::: propagate genlmsg_reply return code

-- 
https://patchwork.kernel.org/patch/10819185/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

