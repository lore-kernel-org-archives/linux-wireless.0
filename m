Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6B1C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 09:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFAA82085A
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 09:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbfCYJc2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 05:32:28 -0400
Received: from nbd.name ([46.4.11.11]:41182 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfCYJc1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 05:32:27 -0400
Received: from p548c84a0.dip0.t-ipconnect.de ([84.140.132.160] helo=[192.168.45.69])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1h8Lxy-0006NG-N6; Mon, 25 Mar 2019 10:32:26 +0100
Subject: Re: [PATCH] mac80211: HE: add Spatial Reuse IE parsing support
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190325082057.26710-1-john@phrozen.org>
 <b781d983f2f5792a671a66075eaee6f3515aba6f.camel@sipsolutions.net>
From:   John Crispin <john@phrozen.org>
Message-ID: <35365073-703e-5288-47a4-ff95efa89b68@phrozen.org>
Date:   Mon, 25 Mar 2019 10:32:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <b781d983f2f5792a671a66075eaee6f3515aba6f.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 25/03/2019 09:49, Johannes Berg wrote:
> On Mon, 2019-03-25 at 09:20 +0100, John Crispin wrote:
>> Add support to mac80211 for parsing SPR IEs as per
>> P802.11ax_D3.0 section 9.4.2.241.
> Hmm, if you're not going to use it, why parse it? Am I missing a follow-
> up patch?
>
> Also, consider checking against D4.0, Luca just sent a patch to update
> to that for all the rest of the code.
>
> johannes
>
Hi Johannes,

This patch is in preparation for the upcoming OBBS PD support inside 
Kalle's ath11k-bringup tree. Forgot to mention that sorry.

I'll also check against D4.0.

     John

