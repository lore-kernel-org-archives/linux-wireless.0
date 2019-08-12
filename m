Return-Path: <SRS0=TJSc=WI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D16C31E40
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Aug 2019 07:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 082E92085A
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Aug 2019 07:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfHLHhY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Aug 2019 03:37:24 -0400
Received: from smtp1.goneo.de ([85.220.129.30]:55118 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfHLHhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Aug 2019 03:37:24 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 03:37:23 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id 0FFD123F037;
        Mon, 12 Aug 2019 09:28:04 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X6NG7wCyM0OW; Mon, 12 Aug 2019 09:28:03 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPSA id E38F923FA49;
        Mon, 12 Aug 2019 09:28:02 +0200 (CEST)
Date:   Mon, 12 Aug 2019 09:40:49 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PING 2] [PATCH v5 1/7] nfc: pn533: i2c: "pn532" as dt
 compatible string
Message-ID: <20190812074035.GA9797@lem-wkst-02.lemonage>
References: <20190111161812.26325-1-poeschel@lemonage.de>
 <20190228104801.GA14788@lem-wkst-02.lemonage>
 <20190403094735.GA19351@lem-wkst-02.lemonage>
 <20190805124236.GG3574@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805124236.GG3574@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Aug 05, 2019 at 02:42:36PM +0200, Johan Hovold wrote:
> You may want to resend this series to netdev now. David Miller will be
> picking up NFC patches directly from there.

Thank you very much for this information. Johannes Berg did reach out to
me already.
Rebase, test and resend is queued up for one of my next free timeslots.

Thanks again,
Lars
