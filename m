Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9344EC197A0
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Nov 2023 13:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344962AbjKPNnI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Nov 2023 08:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjKPNnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2023 08:43:07 -0500
X-Greylist: delayed 218 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Nov 2023 05:43:03 PST
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC97CC1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Nov 2023 05:43:03 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1700142182; bh=L8ieHE3R7PwqqdCA4Atyk/z+p9cxUJiSaonkIkRlgQQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=T7g7228u99Kru0a9u/zbdcjUmZWdlHCKTMAwr3cFpUpZusrLM0frVKZag59jVac7I
         BMwMBw8thnqshMacEcxLh5Q+yE+o+9NDvuXeSIkANcMghZ/NP7yHgBXUV326t4EaK+
         qTXS22mx8Gkbt0A2OFxDfub/gSR21JV3UAAAsJyUKMkin9pDNAxOXPJZNJQ1b6KvDI
         2WeWqApMm2Q0GzveZNX9n/Y5O5Vfh/vxO7j34P7vNXG0dnPLK1tzFEacms9G6DjeRO
         w0szu4d/t+RThMIvef7/eWwyjxV98YP3Lemziib1CE7AKthHo41zrtOUIg83j4YTtO
         OLX0sN+Rj1bpA==
To:     Wenli Looi <wlooi@ucalgary.ca>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH v3 00/11] wifi: ath9k: add support for QCN550x
In-Reply-To: <YQXPR01MB3302EAE07CAC3989D352C054B2B3A@YQXPR01MB3302.CANPRD01.PROD.OUTLOOK.COM>
References: <20230629231625.951744-1-wlooi@ucalgary.ca>
 <YQXPR01MB3302EAE07CAC3989D352C054B2B3A@YQXPR01MB3302.CANPRD01.PROD.OUTLOOK.COM>
Date:   Thu, 16 Nov 2023 14:43:01 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87il61dday.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wenli Looi <wlooi@ucalgary.ca> writes:

> I've updated the following github pull request to show how this patch
> can be incorporated into OpenWrt to provide 2.4GHz wifi support for
> all QCN5502 devices: https://github.com/openwrt/openwrt/pull/9389
>
> There are prebuilt images for all existing QCN5502 devices, and it is
> also possible to build from source for any device.
>
> Hopefully this can provide some context on how this driver can be
> useful, and can be a source of feedback from others who try out the
> driver.

Thanks! FWIW, I don't have any objections in principle to merging this,
but I'm not comfortable doing so until someone has reviewed it. So
anything you can do to help find a reviewer will be helpful :)

-Toke
