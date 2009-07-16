Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58723 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZGPICa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 04:02:30 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MRLvB-0001uC-99
	for linux-wireless@vger.kernel.org; Thu, 16 Jul 2009 08:02:29 +0000
Received: from cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com ([82.16.102.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 08:02:29 +0000
Received: from jon.fairbairn by cpc2-cmbg9-0-0-cust621.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 08:02:29 +0000
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: PCI express card that does AP mode? (abit wlp-01?)
Date: Thu, 16 Jul 2009 09:02:14 +0100
Message-ID: <wfljmpm4xl.fsf@calligramme.charmers>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A machine I want to set up as an AP has only PCI express slots free...

I've tried looking at the wiki, but I can't easily find an inexpensive
pci express card that will do AP mode. It's the usual problem: shops
don't say what the PCI ids of the device are, and the quoted
manufacturer isn't the manufacturer in the sense needed by the kernel.

I've seen adverts for the Abit WLP-01, and elsewhere on the net seen
implications that it's 168c:001c, which isn't listed at
<http://wireless.kernel.org/en/users/Devices/PCI>, but
<http://wireless.kernel.org/en/users/Drivers/ath5k> does list it and
says AP mode not working, but mentions
<http://madwifi-project.org/wiki/Compatibility/Abit>, which suggest AP
mode works with madwifi. What's the current status?

Alternatively, can anyone recommend a card?

-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


