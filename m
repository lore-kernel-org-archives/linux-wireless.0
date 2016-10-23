Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rs224.mailgun.us ([209.61.151.224]:47286 "EHLO rs224.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934089AbcJWOGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Oct 2016 10:06:18 -0400
Received: by mail-qk0-f179.google.com with SMTP id o68so206487734qkf.3
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2016 06:57:24 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjorn@openias.org>
Date: Sun, 23 Oct 2016 15:57:23 +0200
Message-ID: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com> (sfid-20161023_160622_798535_C6DAB0EF)
Subject: Bayesian rate control
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I've been thinking about rate control a bit lately. I've written up
some of my thoughts in a blog post
(http://www.openias.org/bayesian-wifi-rate-control), but very briefly
put I'd like to build a rate control algorithm based on Bayesian
statistical inference, possibly by modeling the rate control problem
as a "multi-armed bandit" problem and/or using Thompson sampling.

A couple of questions for the list:

1. Is there anybody else out there thinking along similar lines?

I'd very much like to find collaborators interested in working on
this. It could serve as a pretty nice masters thesis problem, for
example.

2. What would be the best hardware/software stack to base this work on?

I'm thinking the best driver for rate control experimentation would be
ath9k, right? If so then a TP-Link TL-WA901ND router (apparently based
on Qualcomm QCA956x SOC) with OpenWrt, and a TP-Link TL-WDN4800 PCIe
card (apparently based on Atheros AR9380 with PCI ID 168c:0030) for my
desktop sounds like a good combo, no? But would I have to run a custom
kernel on my desktop then (or can I somehow get by with an Ubuntu
standard kernel)?

Any other thoughts or pointers are also more than welcome.

Many thanks,

Bj=C3=B6rn Smedman
