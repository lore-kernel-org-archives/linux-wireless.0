Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:39714 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbeHDPIr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Aug 2018 11:08:47 -0400
Received: by mail-qt0-f180.google.com with SMTP id q12-v6so9111787qtp.6
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2018 06:08:08 -0700 (PDT)
Received: from [10.10.10.116] (c-76-100-58-62.hsd1.md.comcast.net. [76.100.58.62])
        by smtp.gmail.com with ESMTPSA id x10-v6sm6729880qta.24.2018.08.04.06.08.06
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Aug 2018 06:08:07 -0700 (PDT)
From: Dan Kosek <daniel.kosek@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: iw scanning broken?
Message-Id: <C17ECAF6-E13C-40DB-A582-C9945D9BE7D7@gmail.com> (sfid-20180804_150912_902834_4E74D4FA)
Date: Sat, 4 Aug 2018 09:08:06 -0400
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you enter the following command, you should get a single channel =
scan:

sudo iw wlan0 scan freq 2412

You do not.  Instead you get a full (all) channels scan, which takes 3-5 =
seconds.

This has been tested on Raspberry Pi Raspian 9 and Peppermint OS 7 ( =
Linux 4.4.0-53-generic #74-Ubuntu) with the same results.

i believe iw is broken or some command knowledge is missing.

Dan

daniel.kosek@gmail.com
