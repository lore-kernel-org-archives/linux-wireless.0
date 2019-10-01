Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8ECC352AA
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 20:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A38CA215EA
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 20:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfJAUsr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 16:48:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56947 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfJAUsr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 16:48:47 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iFP4e-0004kE-9H; Tue, 01 Oct 2019 22:48:44 +0200
Date:   Tue, 1 Oct 2019 22:48:44 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: Support for RTL8188FU
Message-ID: <20191001204844.6gogluy4nchphh7p@linutronix.de>
References: <20191001160305.qrl4nt2jmdsogaaz@linutronix.de>
 <3af284c7-ee46-dd42-9549-de55feae2528@lwfinger.net>
 <20191001174612.4kj3mt3h5epidyyk@linutronix.de>
 <b958b669-a683-d7cd-6bbf-bfe3e674f62d@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b958b669-a683-d7cd-6bbf-bfe3e674f62d@lwfinger.net>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-10-01 13:52:30 [-0500], Larry Finger wrote:
> If that is what you read, that is not what I meant.
> 
> The staging driver is really old and does not support nl80211 and friends.
> If you are willing to undertake a 6 to 12-month rewrite of the driver you
> have, and it supports RTL8188EU, then a replacement of the staging driver
> would be what you should do. If you do not want to make that kind of time
> commitment, then a GitHub repo would be your best bet; however, GitHub
> already has 5 such repos for the rtl8188fu. As far as I can tell, none of
> them are yours.
> 
> The first thing I would do is clone the v5.2.2.4 branch of
> lwfinger/rtl8188eu at GitHub, add the USB ID for your device, and see if
> that works. I expect it will. If so, that would get you quite a ways toward
> the changes needed to get that driver into staging.

Thank you for clearing that up.

> Larry

Sebastian
