Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A5FC433B4
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Apr 2021 07:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9EF61186
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Apr 2021 07:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhDQHkp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Apr 2021 03:40:45 -0400
Received: from mail.ovgu.de ([141.44.1.66]:57218 "EHLO mail.ovgu.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhDQHkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Apr 2021 03:40:45 -0400
Received: from [192.168.0.198] (wh5-67.st.uni-magdeburg.de [141.44.165.67])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.ovgu.de (Postfix) with ESMTPSA id 50D35A020E;
        Sat, 17 Apr 2021 09:40:18 +0200 (CEST)
Subject: Re: Adding a fifth edca tx queue
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <fae3f300-8e04-d9ec-8e22-a401aaa6f70a@st.ovgu.de>
 <60b03f0cc20aa72dd6c6e94bfe2253bd3d21037f.camel@sipsolutions.net>
From:   Johannes Behrens <johannes.behrens@st.ovgu.de>
Message-ID: <49381d82-0392-33a8-9b81-cc5e04f80e0e@st.ovgu.de>
Date:   Sat, 17 Apr 2021 09:40:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <60b03f0cc20aa72dd6c6e94bfe2253bd3d21037f.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 15.04.21 17:40, Johannes Berg wrote:
> On Thu, 2021-04-15 at 18:07 +0200, Johannes Behrens wrote:
>> Hi,
>> currently I am planning to implement a fifth edca tx-queue in the kernel
>> for research purposes for special requirements on the tactile internet.
>>
>> Now I am facing the challenge that I cannot find any actual hardware on
>> which I can implement another queue. Do you have any tips for me there?
> I doubt you'll have much luck with this, but do you really need all 5?
> You could do a lot of experimentation by just changing the EDCA
> parameters of e.g. the mostly unused VO or BK queues.
>
> johannes
>
Thanks for the answer. I do not necessarily need all 5 queues. It would
just be extra nice and reflect my original thoughts. Changing the
parameters of an existing queue is my plan b and is basically sufficient
for the purpose of the research.

Regards Johannes

