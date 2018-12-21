Return-Path: <SRS0=l33s=O6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1248C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 00:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4381218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 00:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388239AbeLUAsF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 19:48:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36014 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731233AbeLUAsF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 19:48:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::cf9])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 759FF1499203C;
        Thu, 20 Dec 2018 16:48:04 -0800 (PST)
Date:   Thu, 20 Dec 2018 16:48:03 -0800 (PST)
Message-Id: <20181220.164803.578401577454574668.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2018-12-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <878t0kt6tu.fsf@kamboji.qca.qualcomm.com>
References: <878t0kt6tu.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Dec 2018 16:48:04 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 20 Dec 2018 20:02:21 +0200

> here's a pull request to net-next for 4.21. More info in the signed
> below.
> 
> As I have been too busy this cycle not all of these have been in
> linux-next, but most of them has been tested by the kbuild bot and the
> last few remaining patches are being tested while I write this. So I'm
> not expecting any major problems, but if you see something do let me
> know.

Pulled, thanks for the merge conflict guidance.

> Happy Holidays and have a great New Year :)

hyv‰‰ joulua!!!
