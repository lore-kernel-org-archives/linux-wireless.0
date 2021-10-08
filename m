Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53579C4332F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Oct 2021 10:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E26D61038
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Oct 2021 10:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239719AbhJHKTg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Oct 2021 06:19:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52424 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239731AbhJHKTb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Oct 2021 06:19:31 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BF6E44FED5494;
        Fri,  8 Oct 2021 03:17:30 -0700 (PDT)
Date:   Fri, 08 Oct 2021 11:16:46 +0100 (BST)
Message-Id: <20211008.111646.1874039740182175606.davem@davemloft.net>
To:     krzysztof.kozlowski@canonical.com
Cc:     k.opasiak@samsung.com, mgreer@animalcreek.com, kuba@kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RESEND PATCH v2 0/7] nfc: minor printk cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 08 Oct 2021 03:17:32 -0700 (PDT)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Date: Thu,  7 Oct 2021 15:30:14 +0200

> Hi,
> 
> This is a rebase and resend of v2. No other changes.
> 
> Changes since v1:
> 1. Remove unused variable in pn533 (reported by kbuild).

Please CC: netdev for nfc patches otherwise they will not get tracked
and applied.

Thank you.
