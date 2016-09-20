Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35172 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755089AbcITR1p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 13:27:45 -0400
Received: by mail-wm0-f46.google.com with SMTP id l132so221615825wmf.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 10:27:44 -0700 (PDT)
MIME-Version: 1.0
From: Gucea Doru <gucea.doru@gmail.com>
Date: Tue, 20 Sep 2016 20:27:42 +0300
Message-ID: <CANfLQrbz1x6q+S2OmWah583=pTJ_6vK1BgnwLPSTk_VnFQ6TsA@mail.gmail.com> (sfid-20160920_192748_852894_9ED81AA6)
Subject: Qualcomm: Power Save Algorithm in STA+STA mode
To: linux-wireless@vger.kernel.org
Cc: Andra Paraschiv <andra.paraschiv7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, everyone

I'm a master student and I currently work on designing an algorithm
for reducing the power consumption when a mobile device is associated
to multiple Access Points that operate on the same channel.

I tried to design my algorithm around the prima driver [1] but I
noticed that the power save feature is fully implemented in the
firmware (Beacon Mode Power Save). Unfortunately, the firmware is
closed-source and I can't do any modifications.

Is there any Qualcomm representative reading this mailing list that
could help me get a possible solution for the above problem?


[1] https://source.codeaurora.org/quic/la

Thank you,
Doru
