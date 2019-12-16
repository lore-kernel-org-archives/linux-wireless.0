Return-Path: <SRS0=mHGl=2G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE91C2D0C3
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 15:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDFCA2146E
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 15:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfLPPw0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Dec 2019 10:52:26 -0500
Received: from nbd.name ([46.4.11.11]:52626 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfLPPwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Dec 2019 10:52:25 -0500
Received: from pd95fd428.dip0.t-ipconnect.de ([217.95.212.40] helo=[192.168.45.104])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1igsfV-0000kE-Ix; Mon, 16 Dec 2019 16:52:22 +0100
Subject: Re: [PATCH v2 2/7] nl80211: add handling for BSS color
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
References: <20191213155802.25491-1-john@phrozen.org>
 <20191213155802.25491-2-john@phrozen.org>
 <a67dd924ebb638a8ba2b742a07fd3d1db34732ce.camel@sipsolutions.net>
From:   John Crispin <john@phrozen.org>
Message-ID: <fc64ea0b-d2c3-79a3-6973-c822078db01f@phrozen.org>
Date:   Mon, 16 Dec 2019 16:52:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a67dd924ebb638a8ba2b742a07fd3d1db34732ce.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 16/12/2019 10:56, Johannes Berg wrote:
> 
> Also, not directly related to any code, can't the BSS color change, and
> thus you need a method to update it?

Coming shortly once I start working on the collission events and then 
the hostapd color change algorithm
	John
