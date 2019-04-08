Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F40C282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F29D22087F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfDHMMG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:12:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53830 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfDHMMG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:12:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDT85-0005z8-Ul; Mon, 08 Apr 2019 14:12:02 +0200
Message-ID: <ed3d254a2e54bd491fd4ed2d6f411ab769ad8ba2.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] nl80211: Allow change CW to Ad-Hock network
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andrea Greco <a.greco@4sigma.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Apr 2019 14:12:00 +0200
In-Reply-To: <20190221231147.6141-1-andrea.greco.gapmilano@gmail.com> (sfid-20190222_001228_859513_32D336A4)
References: <20190221231147.6141-1-andrea.greco.gapmilano@gmail.com>
         (sfid-20190222_001228_859513_32D336A4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-22 at 00:11 +0100, Andrea Greco wrote:
> From: Andrea Greco <a.greco@4sigma.it>
> 
> Add net-link support for change CW in Ad-Hock network

This doesn't really make sense, the ibss code overrides it again once it
actually re-joins etc.

johannes

