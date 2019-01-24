Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE04CC282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982982184C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbfAXSTt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:19:49 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:36818 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfAXSTt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 13:19:49 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmjbN-0005el-07; Thu, 24 Jan 2019 19:19:45 +0100
Message-ID: <3b395c3564bf0c693090b066ec4c598c8d0bdb34.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Remove attribute packed from struct 'action'
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mathieu Malaterre <malat@debian.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 24 Jan 2019 19:19:43 +0100
In-Reply-To: <CA+7wUszXbRt=j1C1PF11EtnO2ojLpvL8Zs60c7UcEDrqjRMxOw@mail.gmail.com> (sfid-20190124_191458_847102_6753A793)
References: <20190124180535.20216-1-malat@debian.org>
         <2b8b377a84883db1a45afb42204d8fb5a7d5ccf9.camel@sipsolutions.net>
         <CA+7wUszXbRt=j1C1PF11EtnO2ojLpvL8Zs60c7UcEDrqjRMxOw@mail.gmail.com>
         (sfid-20190124_191458_847102_6753A793)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-24 at 19:14 +0100, Mathieu Malaterre wrote:

> > I'm not sure this will work on all platforms, didn't something like
> > alpha pad out u8's to u32 when not requiring packing?
> 
> I was not aware of that.

TBH, I'm not actually sure about that. Pure hearsay. If anyone knows,
I'd like to know too :)

johannes

