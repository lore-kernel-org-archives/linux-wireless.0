Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB90C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9521120844
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfBHNCD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:02:03 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48152 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbfBHNCD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:02:03 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs5n8-0007xg-Ey
        for linux-wireless@vger.kernel.org; Fri, 08 Feb 2019 14:02:02 +0100
Message-ID: <453eddecb74fd814146bcb253a66165556769c16.camel@sipsolutions.net>
Subject: Re: [PATCH 1/4] cfg80211: add and use strongly typed element
 iteration macros
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Date:   Fri, 08 Feb 2019 14:02:00 +0100
In-Reply-To: <20190208123154.22414-1-johannes@sipsolutions.net> (sfid-20190208_133206_618228_932A8E9D)
References: <20190208123154.22414-1-johannes@sipsolutions.net>
         (sfid-20190208_133206_618228_932A8E9D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-08 at 13:31 +0100, Johannes Berg wrote:
> 
> +static inline bool for_each_element_completed(struct element *element,
> +					      void *data, size_t datalen)

Those pointer arguments should be const.

johannes

