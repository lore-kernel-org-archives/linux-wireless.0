Return-Path: <SRS0=Zq5x=5F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81434C4332B
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 608C620753
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgCTJtX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Mar 2020 05:49:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35039 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgCTJtX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Mar 2020 05:49:23 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jFEH0-0000vL-B6; Fri, 20 Mar 2020 10:49:02 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     tglx@linutronix.de
Cc:     arnd@arndb.de, balbi@kernel.org, bhelgaas@google.com,
        bigeasy@linutronix.de, dave@stgolabs.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org
Subject: [PATCH 0/5] Remove mm.h from arch/*/include/asm/uaccess.h
Date:   Fri, 20 Mar 2020 10:48:51 +0100
Message-Id: <20200320094856.3453859-1-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200318204408.010461877@linutronix.de>
References: <20200318204408.010461877@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following mini-series removes linux/mm.h from the asm/uaccess.h of
the individual architecture. The series has been compile tested with the
defconfig and additionally for ia64 with the "special" allmodconfig
supplied by the bot. The regular allmod for the architectures does not
compile (even without the series).

Sebastian


