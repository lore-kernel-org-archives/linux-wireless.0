Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f172.google.com ([209.85.208.172]:44679 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbeHGAUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 20:20:15 -0400
Received: by mail-lj1-f172.google.com with SMTP id q127-v6so11797089ljq.11
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2018 15:09:07 -0700 (PDT)
MIME-Version: 1.0
From: Tomasz Kalbarczyk <tkalbar@utexas.edu>
Date: Mon, 6 Aug 2018 18:08:46 -0400
Message-ID: <CAH9jq_Ow7Gt-m1QZoS3-JOEdU1CkC33S2mCfYz4bHNOMDX+q9A@mail.gmail.com> (sfid-20180807_000913_505458_996EB7DA)
Subject: Promiscuous (not monitor) Mode support for ath10k
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a QCA6174 and I'm running tcpdump on the wireless interface to
listen for packets. I can receive packets addressed directly to the
device, but not any other packets on the network.

Does anyone know the status of promiscuous mode support on ath10k?
Note that this is different from monitor mode / supported on a larger
subset of hardware. Dmesg merely indicates that the device has
"entered promiscuous mode" when tcpdump is initiated.

Here is a link to similar discussion regarding the ath9k a few years
back: https://marc.info/?l=linux-wireless&m=135936563626791&w=2

Thanks for the help!
Tomasz
