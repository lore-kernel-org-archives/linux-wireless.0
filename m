Return-Path: <SRS0=5mL6=Z4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493EFC43603
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Dec 2019 19:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28BF224673
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Dec 2019 19:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLFTNc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Dec 2019 14:13:32 -0500
Received: from nbd.name ([46.4.11.11]:55064 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfLFTNc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Dec 2019 14:13:32 -0500
Received: from p5dcfbb47.dip0.t-ipconnect.de ([93.207.187.71] helo=[10.255.191.27])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1idJ2e-0005Tt-6q; Fri, 06 Dec 2019 20:13:29 +0100
Subject: Re: [PATCH 2/7] nl80211: add handling for BSS color
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
References: <20191206143401.4080-1-john@phrozen.org>
 <20191206143401.4080-2-john@phrozen.org>
From:   John Crispin <john@phrozen.org>
Message-ID: <d04c25fc-5ee5-55d0-e192-415d2a96f0d0@phrozen.org>
Date:   Fri, 6 Dec 2019 20:13:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191206143401.4080-2-john@phrozen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 06/12/2019 15:33, John Crispin wrote:
> + * @NL80211_HE_BSS_COLOR: the OBSS PD minimum tx power offset.

copy pasta ... lemme resend a V2 once there has been other review
	John
