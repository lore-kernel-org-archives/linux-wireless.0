Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33762 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944926AbdE0BM3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 21:12:29 -0400
Received: by mail-wr0-f174.google.com with SMTP id w50so9589704wrc.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 18:12:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Fri, 26 May 2017 18:12:18 -0700
Message-ID: <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com> (sfid-20170527_034700_536810_B80AA6A2)
Subject: Re: [PATCH] Per chain RSSI reporting
To: Norik Dzhandzhapanyan <norikd@ethertronics.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[snip]

hiya,

I have something local that I've been meaning to push up to do this,
but with no smoothing. Ideally (!) smoothing is done optionally in
mac80211.

What do you think about just committing the per-chain RSSI stuff to
mac80211 so it shows up right now, and then we figure out how to
express the smoothing in mac80211 or further up the layers?

(We care about packet-to-packet RSSI values for "reasons" - mostly
bring-up and board validation, but also for runtime link checks.)


-adrian
