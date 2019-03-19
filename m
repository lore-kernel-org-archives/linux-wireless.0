Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B780EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 20:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904BE2175B
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 20:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfCSUs1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 16:48:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53332 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfCSUs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 16:48:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49A0714691772;
        Tue, 19 Mar 2019 13:48:26 -0700 (PDT)
Date:   Tue, 19 Mar 2019 13:48:25 -0700 (PDT)
Message-Id: <20190319.134825.713783757593858293.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, sameo@linux.intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix to check for kmemdup failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190319031944.18984-1-pakki001@umn.edu>
References: <20190319031944.18984-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Mar 2019 13:48:26 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Mon, 18 Mar 2019 22:19:44 -0500

> In case of kmemdup failure while setting the service name the patch
> returns -ENOMEM upstream for processing.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied.
