Return-Path: <SRS0=iJrv=PA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17469C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 02:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0323218FD
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 02:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404450AbeLWCmS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 21:42:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404416AbeLWCmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 21:42:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::cf9])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC2EA14BF32B5;
        Sat, 22 Dec 2018 18:42:17 -0800 (PST)
Date:   Sat, 22 Dec 2018 18:42:17 -0800 (PST)
Message-Id: <20181222.184217.692941087610805245.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: af_nfc: Fix Spectre v1 vulnerability
From:   David Miller <davem@davemloft.net>
In-Reply-To: <db8937bf-3dd3-f498-d983-ee98582d9f75@embeddedor.com>
References: <20181221214753.GA2799@embeddedor>
        <20181222.150946.778308321544627589.davem@davemloft.net>
        <db8937bf-3dd3-f498-d983-ee98582d9f75@embeddedor.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Dec 2018 18:42:18 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Sat, 22 Dec 2018 17:37:35 -0600

> I wonder if you can take this one too:
> 
> https://lore.kernel.org/lkml/20181221212229.GA32635@embeddedor/
> 
> It's pretty similar to the af_nfc one.

Sure, done.
