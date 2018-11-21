Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F145DC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 21:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF43320672
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 21:11:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF43320672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lang.hm
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733297AbeKVHrO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Nov 2018 02:47:14 -0500
Received: from h-66-167-227-145.lsan.ca.dynamic.globalcapacity.com ([66.167.227.145]:52008
        "EHLO mail.lang.hm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733229AbeKVHrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Nov 2018 02:47:14 -0500
Received: from asgard.lang.hm (syslog [10.0.0.100])
        by mail.lang.hm (Postfix) with ESMTP id 9922241905;
        Wed, 21 Nov 2018 13:11:12 -0800 (PST)
Date:   Wed, 21 Nov 2018 12:11:05 -0800 (PST)
From:   David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>
cc:     "David P. Reed" <dpreed@deepplum.com>,
        Dave Taht <dave.taht@gmail.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccounting
 and scheduling to TXQs
In-Reply-To: <eb65f613-23b0-737f-fabe-851e6c1abbdd@newmedia-net.de>
Message-ID: <alpine.DEB.2.02.1811211210190.28423@nftneq.ynat.uz>
References: <1542814135.446217011@apps.rackspace.com> <eb65f613-23b0-737f-fabe-851e6c1abbdd@newmedia-net.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 21 Nov 2018, Sebastian Gottschall wrote:

> its not bluetooth. active tire pressure control systems are based on 433 mhz 
> in most countries. in the usa its 315 mhz

Thanks for the correction. My off-hand comment has sure spurred an intersting 
side-thread.

David Lang
