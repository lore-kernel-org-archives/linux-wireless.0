Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D473DC433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Sep 2021 14:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4552611EE
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Sep 2021 14:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbhIVOUA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbhIVOT7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Sep 2021 10:19:59 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397C9C06175F;
        Wed, 22 Sep 2021 07:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=4n0VEAk/fGGueYQaeOGAUpveXsFvYVIDnzHQ9qCNW9U=;
        t=1632320309; x=1633529909; b=a0hM+uAb75K04Nh8ozlYd9fS01wL6yIcUBJGsFFdRR8ZTLW
        +jc5aHCNf1hfCW5xTmc8aWx8bBRhtAD1V8UsdJ5xKTzAaRH90Sf4qTsD76pFG9GvJuwLnDjxZm0wl
        Nm15LY0ovczgfNzaqVNhQx0meaN2uDrt0I/KMh7K2IsOTOnUjppxJJBsgJmsuQ6ivH8lrzb42yWeQ
        SoSJmIo52vjIBvG1LDyFRWWFXKUnkrnyXeK4ETa7KZ2FKhot4pNzWBZN/eyiZpfVK2MAlF45G01t1
        tC1ov9UKdeGfcIMBYYm1gXRF6b9Xre1HNLsVggD7C8EqAietDkImGpCbBo5pcVfg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mT34r-00AKDL-QG;
        Wed, 22 Sep 2021 16:18:25 +0200
Message-ID: <168ff8423d33cae53097f63d5e7386c439b3a82d.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: fix incorrect type in initializer
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net
Date:   Wed, 22 Sep 2021 16:18:24 +0200
In-Reply-To: <20210922141617.189660-1-ramonreisfontes@gmail.com>
References: <20210922141617.189660-1-ramonreisfontes@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2021-09-22 at 11:16 -0300, Ramon Fontes wrote:
> This issue was raised by patchwork at:
> https://patchwork.kernel.org/project/linux-wireless/patch/20210906175350.13461-1-ramonreisfontes@gmail.com/

That wasn't patchwork that was the robot, but ... I don't think I've
even applied that patch, so pleaes resend it with the correction
included.

johannes

