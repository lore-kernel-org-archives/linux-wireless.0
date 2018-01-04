Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:30583 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753141AbeADOZh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 09:25:37 -0500
Date: Thu, 04 Jan 2018 15:25:35 +0100
From: "Dawid Stawiarski" <neeo@xl.wp.pl>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Odp: Re: iwlwifi: mvm: rx ops with kernel >= 4.14
Message-ID: <5a4e395f16e5b3.92275484@wp.pl> (sfid-20180104_152547_856311_67E4EAA4)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > after updating to kernel >= 4.14 (from 4.13.X) my wifi stops working every couple hours with the following stacktrace (I've already updated firmware to latest version):
> >
> > jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: loaded firmware version 17.608620.0 op_mode iwlmvm
> > jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
> > jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: base HW address: d8:fc:93:14:cc:15
> > jan 03 13:28:17 tmi kernel: ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> > [...]
> > jan 03 16:14:05 tmi kernel: iwlwifi 0000:3b:00.0: iwl_pcie_cmdq_reclaim: Read index for DMA queue txq id (0), index 0 is out of range [0-256] 70 70.
> > jan 03 16:14:05 tmi kernel: iwlwifi 0000:3b:00.0: HCMD_ACTIVE already clear for command LQ_CMD
> > jan 03 16:14:05 tmi kernel: frame on invalid queue - is on 0 and indicates 1
> > jan 03 16:14:05 tmi kernel: ------------[ cut here ]------------
>  
> Can you please check if the patch in
> https://bugzilla.kernel.org/show_bug.cgi?id=198265 helps?

I've been testing it since yesterday, and so far so good - no ops. Thanks.
