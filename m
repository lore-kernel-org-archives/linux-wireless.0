Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48318C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 11:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2029920684
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 11:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfBVLDS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:03:18 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35190 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfBVLDS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 06:03:18 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gx8bq-0000er-7g; Fri, 22 Feb 2019 12:03:14 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iw: allow to set wmm parameters from iw
From:   Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20190221231807.6969-1-andrea.greco.gapmilano@gmail.com>
References: <20190221231807.6969-1-andrea.greco.gapmilano@gmail.com>
To:     Andrea Greco <a.greco@4sigma.it>
Cc:     johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        Andrea Greco <a.greco@4sigma.it>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.15
Message-ID: <E1gx8bq-0000er-7g@sipsolutions.net>
Date:   Fri, 22 Feb 2019 06:03:18 -0500
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Andrea Greco <a.greco@4sigma.it> wrote:

> From: Andrea Greco <a.greco@4sigma.it>

please review the contributing file and resend your patch with signed-
off-by. also, i think the printf shouldn't be there.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10824843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

