Return-Path: <SRS0=cxAL=VX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588CBC7618B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 13:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 345BA22BE8
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 13:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfGZN3Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:29:16 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:49098 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZN3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jul 2019 09:29:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hr0Hb-0003p9-6F; Fri, 26 Jul 2019 15:29:15 +0200
Message-ID: <4deeee0289e706d5e594d00d987c233fb8fb25b5.camel@sipsolutions.net>
Subject: Re: [PATCH v5 1/2] nl80211: Add support for EDMG channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Date:   Fri, 26 Jul 2019 15:29:13 +0200
In-Reply-To: <1563194767-4817-2-git-send-email-ailizaro@codeaurora.org>
References: <1563194767-4817-1-git-send-email-ailizaro@codeaurora.org>
         <1563194767-4817-2-git-send-email-ailizaro@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Alexei,

I'm not exactly sure why, but this breaks practically all connectivity
on 2.4 and 5 GHz channels (at least in hwsim tests).

Please check and resubmit.

It'd also be good to reformat the commit log a bit, maybe adding
paragraphs, it's a bit of a "wall of text".

Thanks,
johannes

