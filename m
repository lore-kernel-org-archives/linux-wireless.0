Return-Path: <SRS0=zd0i=XK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45014C4CEC7
	for <linux-wireless@archiver.kernel.org>; Sun, 15 Sep 2019 11:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2315B2054F
	for <linux-wireless@archiver.kernel.org>; Sun, 15 Sep 2019 11:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfIOLiJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 15 Sep 2019 07:38:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfIOLiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Sep 2019 07:38:09 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C140153C1B7C;
        Sun, 15 Sep 2019 04:38:07 -0700 (PDT)
Date:   Sun, 15 Sep 2019 12:38:02 +0100 (WEST)
Message-Id: <20190915.123802.763880169246602189.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2019-09-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87muf5df3i.fsf@kamboji.qca.qualcomm.com>
References: <87r24jchgv.fsf@kamboji.qca.qualcomm.com>
        <20190914.140843.945413345284987204.davem@davemloft.net>
        <87muf5df3i.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 04:38:08 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Sun, 15 Sep 2019 13:32:49 +0300

> David Miller <davem@davemloft.net> writes:
> 
>> From: Kalle Valo <kvalo@codeaurora.org>
>> Date: Sat, 14 Sep 2019 13:14:40 +0300
>>
>>> here's a pull request to net-next tree for v5.4, more info below. Please
>>> let me know if there are any problems.
>>
>> Pulled, thanks Kalle.
> 
> Thanks for pulling this but I don't see it in net-next, maybe you forgot
> to push? Nothing important, just making sure it didn't get lost.

I feel asleep while the build test was running, it should be there now :-)
