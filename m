Return-Path: <SRS0=9MBB=63=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3856CA90AF
	for <linux-wireless@archiver.kernel.org>; Wed, 13 May 2020 09:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D8D206D6
	for <linux-wireless@archiver.kernel.org>; Wed, 13 May 2020 09:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388259AbgEMJ6r convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 May 2020 05:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388188AbgEMJ6p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 May 2020 05:58:45 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC793C061A0E
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2020 02:58:44 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jYo9y-0006nq-46; Wed, 13 May 2020 11:58:42 +0200
Date:   Wed, 13 May 2020 11:58:41 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        pkshih@realtek.com, kevin_yang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v3 0/7] rtw88: extract chip tables from core module
Message-ID: <20200513095841.ea6332ya36jusu57@linutronix.de>
References: <20200512103120.5280-1-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200512103120.5280-1-yhchuang@realtek.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-05-12 18:31:13 [+0800], yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> [Note]: this patch set is based on
>    "[v3,0/9] rtw88: 8723d: Add RF calibration and coex"
>    https://patchwork.kernel.org/cover/11542823/
> 
> The PCI series devices RTL8822BE/RTL8822CE/RTL8723DE used to load
> two kernel modules rtw88.ko/rtwpci.ko into the kernel. The rtw88.ko
…

The split is very nice.
  Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
