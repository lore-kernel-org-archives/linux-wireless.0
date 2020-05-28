Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867DBC433E1
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 15:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FA7820888
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 15:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403844AbgE1PAp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 11:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403849AbgE1PAo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 11:00:44 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BB6C08C5C6
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 08:00:43 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jeK1R-0002dE-PG; Thu, 28 May 2020 17:00:41 +0200
Date:   Thu, 28 May 2020 17:00:41 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        tehuang@realtek.com
Subject: Re: [PATCH 3/7] rtw88: 8821c: add dig related settings
Message-ID: <20200528150041.thk3nqgz5somu42q@linutronix.de>
References: <20200520052335.22466-1-yhchuang@realtek.com>
 <20200520052335.22466-4-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200520052335.22466-4-yhchuang@realtek.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-05-20 13:23:31 [+0800], yhchuang@realtek.com wrote:
> From: Tzu-En Huang <tehuang@realtek.com>
> 
> To improve user experience in field, we need DIG to adjust
> RX initial gain depends on field situation. Since each chip
> has its own register address, this commit defines 8821c specific
> addresses.

To improve user experience in field, we need DIG to adjust RX initial
gain depends on field situation. 

Define the register address for 8821c.
 
> Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Sebastian
