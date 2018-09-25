Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863B2C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49723208D9
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:22:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49723208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbeIYN2n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 09:28:43 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45118 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbeIYN2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 09:28:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g4hfz-000100-HJ
        for linux-wireless@vger.kernel.org; Tue, 25 Sep 2018 09:22:31 +0200
Message-ID: <1537860139.3269.4.camel@sipsolutions.net>
Subject: list archive
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Tue, 25 Sep 2018 09:22:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

Konstantin has graciously added this list to lore, so we now have a web
archive here:

https://lore.kernel.org/linux-wireless

As it's done with public-inbox, you can also git clone the archive
and/or access it via NNTP. Somebody just needs to write a gmane-like
interface for it ;-)

Jouni and I bundled our archives together so it should have practically
all messages (I removed most spam and I know it's missing at least one
that didn't have a message-id) from the start of the old list John
Linville hosted (wireless@lists.tuxdriver.org), which was at the end of
January 2007. Prior to that, wireless discussions were also on netdev.

johannes
