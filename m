Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115EEC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEEB320827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEEB320827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbeKIVk2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:40:28 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56930 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKIVk2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:40:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL5SH-00045g-UF; Fri, 09 Nov 2018 13:00:06 +0100
Message-ID: <78adf728bab8943152dc4db311c50fedbe5710f1.camel@sipsolutions.net>
Subject: Re: [PATCH 1/6] mac80211: Add TXQ scheduling API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date:   Fri, 09 Nov 2018 13:00:04 +0100
In-Reply-To: <1540033534-11211-2-git-send-email-rmanohar@codeaurora.org> (sfid-20181020_130555_381291_6F3867B0)
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
         <1540033534-11211-2-git-send-email-rmanohar@codeaurora.org>
         (sfid-20181020_130555_381291_6F3867B0)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2018-10-20 at 04:05 -0700, Rajkumar Manoharan wrote:
> 
> + * @txq: pointer obtained from station or virtual interface, or from
> + *       ieee80211_next_txq()

nit: please just indent by a single tab for continuation, trying to line
it all up doesn't really make it more readable

I see you're still discussing all this, so I'm going to assume you'll
resend this series eventually :-)

johannes

