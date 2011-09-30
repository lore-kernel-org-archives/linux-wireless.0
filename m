Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35389 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1I3OZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 10:25:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1R9e1S-0002iu-RH
	for linux-wireless@vger.kernel.org; Fri, 30 Sep 2011 16:25:07 +0200
Received: from host240-14-dynamic.13-79-r.retail.telecomitalia.it ([79.13.14.240])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 16:25:06 +0200
Received: from gaigo88 by host240-14-dynamic.13-79-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 16:25:06 +0200
To: linux-wireless@vger.kernel.org
From: v4mp <gaigo88@hotmail.it>
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
Date: Fri, 30 Sep 2011 14:20:02 +0000 (UTC)
Message-ID: <loom.20110930T160704-310@post.gmane.org> (sfid-20110930_162512_595775_C2F3079D)
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello larry,

i've an ALFA AWUS036NHR and i tried latest compat-wireless-2011-09-27 on ubuntu
natty 3.0.4-030004-generic, 
the adapter is recognized as rtl8192cu but is not
responding, no network is detected.

Then if i try to "modprobe -r rtl8192cu" results
FATAL: Error removing rtl8192cu
(/lib/modules/3.0.4-030004-generic/updates/drivers/net/wireless/rtlwifi
/rtl8192cu/rtl8192cu.ko):
Device or resource busy

seems that remains blocked..i can't do anything

tried dmesg and it says

.....
.....
[ 2610.093638] rtlwifi: reg 0xc1c, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed827478
[ 2610.093645] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 2610.093650] rtlwifi: reg 0xc4c, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed827478
[ 2610.093656] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 2610.093662] rtlwifi: reg 0xc78, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed827478
[ 2610.093668] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 2610.093683] rtlwifi: reg 0xc80, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed827478
[ 2610.234960] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 2610.255767] ADDRCONF(NETDEV_UP): wlan1: link is not ready

don't know what to do, waiting for an help :)





