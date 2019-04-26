Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D65CC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076EB2084F
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfDZJsf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:48:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54790 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfDZJse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:48:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJxT7-00005a-Ev
        for linux-wireless@vger.kernel.org; Fri, 26 Apr 2019 11:48:33 +0200
Message-ID: <25b58249576fd5a266464bc7a13a8f7e4d4344a0.camel@sipsolutions.net>
Subject: [ANN] resend patches or respond to 0-day reports
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Apr 2019 11:48:32 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

Just in case it wasn't clear already - if you get a 0-day report with
something that's trivially fixed (like missing documentation etc.)
please resend the patches immediately.

I'd rather have a resend than to comment and then wait later for both
changes, or to have to double-check that those things were later
addressed (or wait for 0-day again).

Thanks,
johannes

