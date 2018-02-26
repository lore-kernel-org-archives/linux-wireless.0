Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34713 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbeBZTtS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 14:49:18 -0500
Received: by mail-lf0-f54.google.com with SMTP id l191so24034368lfe.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 11:49:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519634437-6672-1-git-send-email-mkenna@codeaurora.org>
References: <1519634437-6672-1-git-send-email-mkenna@codeaurora.org>
From: Joshua Zhao <swzhao@gmail.com>
Date: Mon, 26 Feb 2018 11:49:16 -0800
Message-ID: <CAKmTU=ptKUweW-WgoJiZRPS=6X+8q60XX2nHQwsqf=A1j-18iQ@mail.gmail.com> (sfid-20180226_204927_005137_9ACE8584)
Subject: Re: [PATCH v2] ath10k: debugfs support to get final TPC stats for
 10.4 variants
To: mkenna@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

as you said:
        The existing tpc_stats debugfs file provides the dump which is
minimum of target power and regulatory domain.
                        cat /sys/kernel/debug/ieee80211/phyX/ath10k/tpc_sta=
ts

I=E2=80=99m curious what=E2=80=99s exact difference w/ this new addition:
        Export the final Transmit Power Control (TPC) value, which is
the minimum of control power and existing TPC value to user space via
a new debugfs file "tpc_stats_final" to help with debugging.

Can you clarify or give examples on the difference?

Thanks!
