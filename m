Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971E0C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 08:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5101420658
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 08:37:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5101420658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbeJVQz1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 12:55:27 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45030 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbeJVQz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 12:55:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gEVih-0005j9-VK; Mon, 22 Oct 2018 10:37:52 +0200
Message-ID: <90015710a62fa0a6d9da17f5760616101b19c206.camel@sipsolutions.net>
Subject: Re: 4.18.16: memory leak in sta_set_sinfo
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Johannes Stezenbach <js@sig21.net>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        linux-wireless@vger.kernel.org
Date:   Mon, 22 Oct 2018 10:37:36 +0200
In-Reply-To: <20181022083552.GA6878@sig21.net>
References: <20181022080214.GA6379@sig21.net>
         <f1f5e0839f4b1b68510b9db398995c859a19a19e.camel@sipsolutions.net>
         <20181022083552.GA6878@sig21.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-22 at 10:35 +0200, Johannes Stezenbach wrote:

> > commit 848e616e66d4592fe9afc40743d3504deb7632b4
> > Author: Stefan Seyfried <seife+kernel@b1-systems.com>
> > Date:   Sun Sep 30 12:53:00 2018 +0200
> > 
> >     cfg80211: fix wext-compat memory leak
> > 
> > Hopefully that'll eventually propagate to stable.
> 
> Good to know it's fixed, but "hopefully" makes me wonder,
> I'd love to hear the confirmation that it's been queued.

Well, normally it works automatically when you have a Fixes tag, so I
don't usually try to queue anything manually. Maybe Greg has had his
hands full with the 4.19 release :-)

johannes

