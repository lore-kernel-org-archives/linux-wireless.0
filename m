Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A86ECE587
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 16:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50BE72133F
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 16:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732989AbfJAQDI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 12:03:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55663 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJAQDI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 12:03:08 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iFKcE-0005bI-2i; Tue, 01 Oct 2019 18:03:06 +0200
Date:   Tue, 1 Oct 2019 18:03:05 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Larry.Finger@lwfinger.net, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Support for RTL8188FU
Message-ID: <20191001160305.qrl4nt2jmdsogaaz@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I'm looking into support for RTL8188FU with the vendor driver next to
me. There is a driver called rtl8188eu in staging. Is there a way to
figure out the difference between E and F?
Then there is rtl8xxxu outside of staging claiming to support
RTL8188[CR]U. No idea what C & R is and how much difference there is
towards F or E.

Any suggestions what would be the best way towards support for the F
chip?

Sebastian
