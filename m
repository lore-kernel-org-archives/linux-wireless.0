Return-Path: <SRS0=6QqY=34=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCFEC35250
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Feb 2020 14:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E21E021775
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Feb 2020 14:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgBHODm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Feb 2020 09:03:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgBHODl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Feb 2020 09:03:41 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F302714DD3D9D;
        Sat,  8 Feb 2020 06:03:39 -0800 (PST)
Date:   Sat, 08 Feb 2020 15:03:38 +0100 (CET)
Message-Id: <20200208.150338.18665425426357890.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-02-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87sgjlxryp.fsf@kamboji.qca.qualcomm.com>
References: <87sgjlxryp.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Feb 2020 06:03:41 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Sat, 08 Feb 2020 13:02:06 +0200

> here's a pull request to net tree for v5.6, more info below. Please let
> me know if there are any problems.

Pulled, thanks Kalle.
