Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFA0C61DB3
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Jan 2023 12:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbjAMMWi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Jan 2023 07:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjAMMWF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2023 07:22:05 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6A7559E7;
        Fri, 13 Jan 2023 04:18:01 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pGJ0Q-0002KA-L5; Fri, 13 Jan 2023 13:17:58 +0100
Message-ID: <be49babe-46ff-5a80-21db-c8b4562bc17a@leemhuis.info>
Date:   Fri, 13 Jan 2023 13:17:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: ieee80211_handle_wake_tx_queue and dynamic ps regression
Content-Language: en-US, de-DE
To:     Bryan O'Donoghue <pure.logic@nexus-software.ie>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        linux-kernel@vger.kernel.org, johannes.berg@intel.com,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <19015168-c747-17b7-f0ae-9d2ee27d221c@linaro.org>
 <06f76774-1b2e-f563-7128-7d5b9547dfe9@linaro.org>
 <cf5e9339-2511-1135-71da-a8342b264414@linaro.org>
 <205fb221-f7ad-8f03-2c16-54dcbf5ecaf9@wetzel-home.de>
 <53b23ee9-a333-120e-8b58-cfa3a9bdaefc@wetzel-home.de>
 <aace6523-0941-903e-6b80-399dc1cfc751@nexus-software.ie>
From:   "Linux kernel regression tracking (#update)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <aace6523-0941-903e-6b80-399dc1cfc751@nexus-software.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1673612281;60bbecd8;
X-HE-SMSGID: 1pGJ0Q-0002KA-L5
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 10.01.23 20:35, Bryan O'Donoghue wrote:
> On 10/01/2023 15:43, Alexander Wetzel wrote:
>> Looks like the the commit
>> https://patchwork.kernel.org/project/linux-wireless/patch/20221230121850.218810-1-alexander@wetzel-home.de/
>> has a good chance to solve the issue:
> [..]
>> Does that make sense? And more crucial, is the patch fixing that for you?
> 
> Ok works for me.

In that case:

#regzbot fix: wifi: mac80211: Proper mark iTXQs for resumption

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

