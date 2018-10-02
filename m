Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F5CC43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6BA62082A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:47:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6BA62082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbeJCBbv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 21:31:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbeJCBbv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 21:31:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1c06::30d2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68D3B1420756A;
        Tue,  2 Oct 2018 11:47:05 -0700 (PDT)
Date:   Tue, 02 Oct 2018 11:47:04 -0700 (PDT)
Message-Id: <20181002.114704.1259775809107473278.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2018-10-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87ftxojn1l.fsf@kamboji.qca.qualcomm.com>
References: <87ftxojn1l.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.7 on Emacs 26 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Oct 2018 11:47:05 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 02 Oct 2018 20:06:30 +0300

> here's the first pull request to net-next for 4.20. This is rather large
> due to mt76 refactoring and me not being able to send the pull request
> earlier, sorry about that.
> 
> Most of this has been in linux-next for some time now so I'm hoping
> there should not be any nasty surprises, but please let me know if you
> have any problems.

Pulled, thanks Kalle.
