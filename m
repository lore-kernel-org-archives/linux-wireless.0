Return-Path: <SRS0=oQqf=7S=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B55C433DF
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Jun 2020 11:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75365206FA
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Jun 2020 11:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgFELSb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Jun 2020 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgFELSb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Jun 2020 07:18:31 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E85C08C5C2
        for <linux-wireless@vger.kernel.org>; Fri,  5 Jun 2020 04:18:31 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jhAMn-0002kz-IJ; Fri, 05 Jun 2020 13:18:29 +0200
Date:   Fri, 5 Jun 2020 13:18:29 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        tehuang@realtek.com
Subject: Re: [PATCH v3 0/7] rtw88: 8821c: add basic function routines
Message-ID: <20200605111829.pf6hmgmkfjqfl5gm@linutronix.de>
References: <20200603093804.19779-1-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200603093804.19779-1-yhchuang@realtek.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-06-03 17:37:57 [+0800], yhchuang@realtek.com wrote:
> v1 -> v2
>   * rebase on top of tree
> 
> v2 -> v3
>   * fix some wordings
>   * give register definition possible

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
