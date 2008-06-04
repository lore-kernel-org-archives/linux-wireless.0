Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55043 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbYFDWrC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 18:47:02 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K41kx-0003ga-Ne
	for linux-wireless@vger.kernel.org; Wed, 04 Jun 2008 22:47:00 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 22:46:59 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 22:46:59 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: hostap instability in next-20080604
Date: Wed, 04 Jun 2008 23:46:48 +0100
Message-ID: <g2760n$7f0$1@ger.gmane.org> (sfid-20080605_004706_833583_EFC07E5C)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hostap_pci on a 32bit x86 machine seems to be unstable under load in
next-20080604. Using iperf between a wired machine on the other side of the
AP and the hostap box makes hostap output the message
wifi0: SW TICK stuck? bits=0x0 EvStat=8000 IntEn=e09f
before things slowly grind to a halt in a lockup that seemingly needs a
sysrq reboot. This problem seems to be reproducible every time but does not
happen with Ubuntu's 2.6.22 kernel. 

-- 
Sitsofe | http://sucs.org/~sits/

