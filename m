Return-Path: <SRS0=B82j=6O=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE230C8300B
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 09:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B63B9214D8
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 09:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD3Jaz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Apr 2020 05:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726358AbgD3Jaz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Apr 2020 05:30:55 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97881C035494;
        Thu, 30 Apr 2020 02:30:55 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jU5Wk-0007dD-RY; Thu, 30 Apr 2020 11:30:43 +0200
Date:   Thu, 30 Apr 2020 11:30:42 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     ChenTao <chentao107@huawei.com>
Cc:     yhchuang@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtw88: mac: Make some functions static
Message-ID: <20200430093042.lwnp2utcrjwewa5o@linutronix.de>
References: <20200425085304.153077-1-chentao107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200425085304.153077-1-chentao107@huawei.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-04-25 16:53:04 [+0800], ChenTao wrote:
> Fix the following warning:

This has been taken care of:
   3d8bf50860c7d ("rtw88: fix sparse warnings for download firmware routine")

Sebastian
