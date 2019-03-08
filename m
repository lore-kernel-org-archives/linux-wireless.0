Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F944C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F3DA20449
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfCHNA1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:00:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfCHNAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 08:00:23 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C100307E078;
        Fri,  8 Mar 2019 13:00:23 +0000 (UTC)
Received: from localhost (unknown [10.40.205.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC55D600C8;
        Fri,  8 Mar 2019 13:00:22 +0000 (UTC)
Date:   Fri, 8 Mar 2019 14:00:21 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>
Subject: Re: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable
 functionalities
Message-ID: <20190308130021.GA4108@redhat.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AE4FD@RTITMBSVM04.realtek.com.tw>
 <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 08 Mar 2019 13:00:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 08, 2019 at 12:39:51PM +0200, Kalle Valo wrote:
> Once everyone are happy about the driver, at least it needs a review
> from Johannes and me but reviews from others is more than welcome. I
> also saw that Brian gave good comments but not sure if he thinks the
> driver is ready for upstream?
> 
> An ideal schedule is to apply the driver just after the -rc1 is release,
> so within two weeks time. That way we have maximum time to fix any
> problems which might arise.
> 
> Did Stanislaw already review this driver? I don't see any mentioning of
> that in the cover letter[1].

I haven't done that for v3 and later, but v2 of rtw88 was more or less
ok for me (did not see anything wrong that could not be fixed after
inclusion). Anyway, happy to do the review if it helps to merge the
driver.

Stanislaw
