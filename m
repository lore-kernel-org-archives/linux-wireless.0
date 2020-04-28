Return-Path: <SRS0=qsgd=6M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B501C83000
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Apr 2020 08:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75BAD206A5
	for <linux-wireless@archiver.kernel.org>; Tue, 28 Apr 2020 08:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgD1IRA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 Apr 2020 04:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgD1IRA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Apr 2020 04:17:00 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7407BC03C1A9
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2020 01:17:00 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTLQI-000xW0-DS; Tue, 28 Apr 2020 10:16:58 +0200
Message-ID: <9a21da0be7d6fc70541adff2cdb676eb7b04070e.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] staging: rtl8723bs: remove mgmt_frame_register
 method
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, Sergey Matyukevich <geomatsi@gmail.com>
Date:   Tue, 28 Apr 2020 10:16:57 +0200
In-Reply-To: <20200428101400.ae19d651ec38.Ieb15844bb5ab93b3d7931d6561f42e3316ef8251@changeid> (sfid-20200428_101418_130430_853FD716)
References: <20200428101400.ae19d651ec38.Ieb15844bb5ab93b3d7931d6561f42e3316ef8251@changeid>
         (sfid-20200428_101418_130430_853FD716)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg,

I'm going to take these through my tree because I broke the APIs there
(and wasn't paying attention to staging), but every bot around the world
is complaining now that my tree doesn't build ... :)

johannes

