Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f176.google.com ([209.85.208.176]:38264 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbeICW5z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 18:57:55 -0400
Received: by mail-lj1-f176.google.com with SMTP id p6-v6so1128029ljc.5
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2018 11:36:29 -0700 (PDT)
MIME-Version: 1.0
From: Kan Yan <kyan@google.com>
Date: Mon, 3 Sep 2018 11:36:27 -0700
Message-ID: <CA+iem5t_UShavy2BwdQt1nJk=CQwepLR3p6g4k0UEf8ZMqKSvw@mail.gmail.com> (sfid-20180903_203632_952615_E84CFD62)
Subject: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wen Gong,

Do you also have throughput and latency data for different
sk_pacing_shift setting when the ath10k client is at some distance
away from AP? Just curious about its impact on latency with less than
ideal PHY rate.

Thanks,
Kan
