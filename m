Return-Path: <SRS0=sGgU=4D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7B4C7114D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Feb 2020 10:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3F72083B
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Feb 2020 10:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgBOKkK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Feb 2020 05:40:10 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:58915 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbgBOKkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Feb 2020 05:40:10 -0500
Received: from [192.168.0.5] (ip5f5af787.dynamic.kabel-deutschland.de [95.90.247.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E668520643C59;
        Sat, 15 Feb 2020 11:40:06 +0100 (CET)
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc:     linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Non-working Web site URL in MAINTAINERS
Message-ID: <b5cfc13d-8d26-65e3-0377-8d53979c0096@molgen.mpg.de>
Date:   Sat, 15 Feb 2020 11:40:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dear Linux folks,


http://intellinuxwireless.org redirects to [1], and that page is not 
found (404 error).

If you fix this, maybe you can also set up HTTPS.


Kind regards,

Paul


[1]: http://wireless.kernel.org/en/users/Drivers/iwlwifi
