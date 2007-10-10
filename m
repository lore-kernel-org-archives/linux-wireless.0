Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53106 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbXJJMVW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 08:21:22 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IfaYs-000229-7e
	for linux-wireless@vger.kernel.org; Wed, 10 Oct 2007 12:21:14 +0000
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 12:21:14 +0000
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 12:21:14 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: rt2500pci 2.0.9 not working
Date: Wed, 10 Oct 2007 14:17:39 +0200
Message-ID: <feig3h$urf$1@sea.gmane.org> (sfid-20071010_132127_504922_08284881)
References: <fdqhn4$qab$1@sea.gmane.org> <fei4sd$mm0$1@sea.gmane.org> <1192008384.12541.8.camel@johannes.berg> <fei71k$tu7$1@sea.gmane.org> <1192009901.12541.15.camel@johannes.berg> <feibbk$de1$1@sea.gmane.org> <1192015848.12541.20.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> The same error 19?

Precisely. I'm quite sure it did recompile ieee80211_ioctl.c after I applied
your patch, and I've double-checked that I installed the correct kernel...

Oct 10 12:53:59 better kernel: phy0 -> rt2x00mac_conf_tx: Info - Configured
TX ring 0 - CWmin: 5, CWmax: 10, Aifs: 2.
Oct 10 12:53:59 better kernel: phy0 -> rt2x00mac_conf_tx: Info - Configured
TX ring 1 - CWmin: 5, CWmax: 10, Aifs: 2.
Oct 10 12:53:59 better kernel: phy0 -> rt2x00mac_conf_tx: Info - Configured
TX ring 7 - CWmin: 6, CWmax: 10, Aifs: 2.
Oct 10 12:53:59 better kernel: wlan0: Initial auth_alg=0
Oct 10 12:53:59 better kernel: wlan0: authenticate with AP 00:14:6c:a7:60:10
Oct 10 12:53:59 better kernel: wlan0: RX authentication from
00:14:6c:a7:60:10 (alg=0 transaction=2 status=0)
Oct 10 12:53:59 better kernel: wlan0: authenticated
Oct 10 12:53:59 better kernel: wlan0: associate with AP 00:14:6c:a7:60:10
Oct 10 12:53:59 better kernel: wlan0: invalid aid value 0; bits 15:14 not
set
Oct 10 12:53:59 better kernel: wlan0: RX AssocResp from 00:14:6c:a7:60:10
(capab=0x431 status=19 aid=0)
Oct 10 12:53:59 better kernel: wlan0: AP denied association (code=19)
Oct 10 12:53:59 better kernel: wlan0: associate with AP 00:14:6c:a7:60:10
Oct 10 12:53:59 better kernel: wlan0: invalid aid value 0; bits 15:14 not
set
Oct 10 12:53:59 better kernel: wlan0: RX AssocResp from 00:14:6c:a7:60:10
(capab=0x431 status=19 aid=0)
Oct 10 12:53:59 better kernel: wlan0: AP denied association (code=19)
Oct 10 12:53:59 better kernel: wlan0: associate with AP 00:14:6c:a7:60:10
Oct 10 12:53:59 better kernel: wlan0: invalid aid value 0; bits 15:14 not
set
Oct 10 12:53:59 better kernel: wlan0: RX AssocResp from 00:14:6c:a7:60:10
(capab=0x431 status=19 aid=0)
Oct 10 12:53:59 better kernel: wlan0: AP denied association (code=19)
Oct 10 12:53:59 better kernel: wlan0: association with AP 00:14:6c:a7:60:10
timed out

> That's weird because if you select a G mode we do 
> advertise short slot/short preamble.

Can I select the mode from the command line?

Marcus


