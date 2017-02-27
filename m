Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:46668 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751617AbdB0LKU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 06:10:20 -0500
Received: from mr6.cc.vt.edu (mr6.cc.vt.edu [IPv6:2607:b400:92:8500:0:af:2d00:4488])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id v1RB8rXm016164
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 06:08:53 -0500
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com [209.85.220.200])
        by mr6.cc.vt.edu (8.14.7/8.14.7) with ESMTP id v1RB8m2i031201
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 06:08:53 -0500
Received: by mail-qk0-f200.google.com with SMTP id a189so90237044qkc.4
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2017 03:08:53 -0800 (PST)
MIME-Version: 1.0
From: Gaurang Ramesh Naik <gaurang@vt.edu>
Date: Mon, 27 Feb 2017 06:08:47 -0500
Message-ID: <CAFc9h7vC4=0Onx66a19x2QXFFTNkEvnpcmxy0koLu3Z6bymtGw@mail.gmail.com> (sfid-20170227_121024_527490_22A5B2B7)
Subject: Subcarrier nulling in ath9k
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is it possible to null specific subcarriers through the ath9k driver
code or ath9k firmware? Or is it completely done at the hardware?

Any help is appreciated.

Thanks,
GN
