Return-Path: <SRS0=Zq5x=5F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6DBC4332B
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC09B20753
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgCTJ5w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Mar 2020 05:57:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42854 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgCTJ5v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Mar 2020 05:57:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jFEPW-00AUFF-Bi; Fri, 20 Mar 2020 10:57:50 +0100
Message-ID: <6ed191860848219ea0fe5be0f3dc31d17d2af026.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Read rx_stats with perCPU pointers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Seevalamuthu Mariappan <seevalam@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 20 Mar 2020 10:57:49 +0100
In-Reply-To: <1584526555-25960-1-git-send-email-seevalam@codeaurora.org>
References: <1584526555-25960-1-git-send-email-seevalam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-03-18 at 15:45 +0530, Seevalamuthu Mariappan wrote:
> Use perCPU pointers to get rx_stats in sta_set_sinfo
> when RSS is enabled

Maybe, if nobody is missing the stats, we should just remove them
entirely? :)

johannes

