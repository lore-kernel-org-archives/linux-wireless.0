Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC201C282DD
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 09:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8538B20870
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 09:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfDHJBe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 05:01:34 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:49896 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfDHJBe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 05:01:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDQ9l-0003vk-1v; Mon, 08 Apr 2019 11:01:33 +0200
Message-ID: <4a71b32faba929fb4f26c3baaea47c6a859eb054.camel@sipsolutions.net>
Subject: Re: [PATCH 0/6] stricter netlink validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>
Date:   Mon, 08 Apr 2019 11:01:31 +0200
In-Reply-To: <20190408090010.GG3201@mtr-leonro.mtl.com>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
         <20190408090010.GG3201@mtr-leonro.mtl.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> This series crashes on mlx4 devices with the following kernel panic.

Yeah, I know. Like I said elsewhere on the thread, I accidentally sent
out the wrong branch (not realizing I had made two). :-(

This should work:
https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/log/?h=netlink-validation

johannes

