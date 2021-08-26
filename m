Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBD8C432BE
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Aug 2021 08:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2428D610A7
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Aug 2021 08:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbhHZIV0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Aug 2021 04:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhHZIVZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Aug 2021 04:21:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E3AC061757
        for <linux-wireless@vger.kernel.org>; Thu, 26 Aug 2021 01:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Xml5XgGGdB6PW/lKHY1O27jJUx5RVOjX8lRawK2JDs4=;
        t=1629966038; x=1631175638; b=EyKPxLM+8srB6UfatpUjRs+A5nC+SXzNHfyk8infZ0heggj
        BrJRPWGcNKYXBjxX5q2Tczy9eh0QIx3IUEYk/oIqtmrErbxp/BsGHawymC2tkE0BB8HaYQMPw3yqm
        cACDLe1Ap2QIg/rEK97+Z8IePd2ZkhsoKVCaYJF+4AKRaFUmyUOR8luOMNy+ylwuM2rMshnMiRg3s
        VeoDBr7foBqHguIHaGKTShRsoBcmYiWeGZ46U6G7VIwtsnxF7jwtWzYd06jVNc9dZjEFUdNZ7t89u
        6aOFo3Z3XHGQsH4WzNuACg7FaUhdJAzvl7bkFncXHwsdsxkoncaVd9xZ3n5eUypQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mJAcj-00G4cy-W2; Thu, 26 Aug 2021 10:20:34 +0200
Message-ID: <6f10eb461590235014179b8b5c8996d407a51015.camel@sipsolutions.net>
Subject: Re: [PATCH v2 2/8] mac80211: add definition of regulatory info in 6
 GHz operation information
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Wen Gong <wgong@codeaurora.org>, ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 26 Aug 2021 10:20:33 +0200
In-Reply-To: <20210820122041.12157-3-wgong@codeaurora.org>
References: <20210820122041.12157-1-wgong@codeaurora.org>
         <20210820122041.12157-3-wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2021-08-20 at 08:20 -0400, Wen Gong wrote:
> IEEE Std 802.11ax™-2021 added regulatory info subfield in HE operation
> element, this patch is to add it in mac80211 definition.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> ---
>  include/linux/ieee80211.h | 4 ++++
>  1 file changed, 4 insertions(+)

Not really mac80211 (subject), but I'll fix.

johannes

