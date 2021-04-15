Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_05,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07355C433ED
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Apr 2021 14:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B8C61222
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Apr 2021 14:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhDOOQz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Apr 2021 10:16:55 -0400
Received: from mail.ovgu.de ([141.44.1.66]:41176 "EHLO mail.ovgu.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhDOOQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Apr 2021 10:16:55 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 10:16:54 EDT
Received: from [192.168.0.198] (wh5-67.st.uni-magdeburg.de [141.44.165.67])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.ovgu.de (Postfix) with ESMTPSA id CDF99A0257
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2021 16:07:35 +0200 (CEST)
From:   Johannes Behrens <johannes.behrens@st.ovgu.de>
Subject: Adding a fifth edca tx queue
To:     linux-wireless@vger.kernel.org
Message-ID: <fae3f300-8e04-d9ec-8e22-a401aaa6f70a@st.ovgu.de>
Date:   Thu, 15 Apr 2021 18:07:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
currently I am planning to implement a fifth edca tx-queue in the kernel
for research purposes for special requirements on the tactile internet.

Now I am facing the challenge that I cannot find any actual hardware on
which I can implement another queue. Do you have any tips for me there?

I have already dug through the code of some drivers of Linux, but
usually it fails because of the firmware of the WIFI chipsets, which
does not support this.

Many thanks and greetings
Johannes


