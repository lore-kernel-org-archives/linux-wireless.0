Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:35319 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZGXPlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 11:41:09 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MUMtN-0005LZ-Bw
	for linux-wireless@vger.kernel.org; Fri, 24 Jul 2009 15:41:05 +0000
Received: from cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com ([82.16.96.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 15:41:05 +0000
Received: from jon.fairbairn by cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 15:41:05 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Date: Fri, 24 Jul 2009 16:40:54 +0100
Message-ID: <wfvdli6qd5.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers> <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers> <1247775641.6841.16.camel@mj> <wfzlau7co1.fsf@calligramme.charmers> <1248449030.21715.23.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:
> I assume the subvendor/subsystem ID is 147b:1033, as reported elsewhere
> and as "lspci -vnn" would show.

Ah, sorry, yes:

lspci -vnn -s 04:00.0
04:00.0 Ethernet controller [0200]: \
         Atheros Communications Inc. AR242x \
         802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
	Subsystem: ABIT Computer Corp. AirPace Wi-Fi [147b:1033]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at fbff0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: ath5k
	Kernel modules: ath5k

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


