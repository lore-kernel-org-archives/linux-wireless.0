Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243DDC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 12:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE17421855
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 12:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbeLRMRK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 07:17:10 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39968 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbeLRMRK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 07:17:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZEJB-0005Mv-D9; Tue, 18 Dec 2018 13:17:09 +0100
Message-ID: <9a07e9fc236ce6d526dfd67ee9b322953525c426.camel@sipsolutions.net>
Subject: Re: [PATCH 13/24] cfg80211: pmsr: fix MAC address setting
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 18 Dec 2018 13:17:07 +0100
In-Reply-To: <20181215090325.31604-14-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
         <20181215090325.31604-14-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2018-12-15 at 11:03 +0200, Luca Coelho wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When we *don't* have a MAC address attribute, we shouldn't
> try to use this - this was intended to copy the local MAC
> address instead, so fix it.


This patch

>  
> +	flush_work(&wdev->pmsr_free_wk);

Erroneously got some other stuff merged into it - dropped.

johannes

