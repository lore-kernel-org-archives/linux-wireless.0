Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39321 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab1JQKHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 06:07:39 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RFk6c-0000Dv-11
	for linux-wireless@vger.kernel.org; Mon, 17 Oct 2011 12:07:38 +0200
Received: from host84-181-dynamic.10-87-r.retail.telecomitalia.it ([87.10.181.84])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 12:07:38 +0200
Received: from gaigo88 by host84-181-dynamic.10-87-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 12:07:38 +0200
To: linux-wireless@vger.kernel.org
From: v4mp <gaigo88@hotmail.it>
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
Date: Mon, 17 Oct 2011 10:07:26 +0000 (UTC)
Message-ID: <loom.20111017T115802-634@post.gmane.org> (sfid-20111017_120745_998773_2639A9F1)
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gmail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T161652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


ok, i've attached the alfa and run rfkill list but it shows that there are no
blocked devices, then i run modprobe rtl8192cu and strangely the alfa has
lighted, but it doesn't work..
i've done dmesg and seen this:

[ 1218.079638] rtlwifi: reg 0xc80, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed545b78
[ 1218.079645] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 1218.079650] rtlwifi: reg 0xc80, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed545b78
[ 1218.079657] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 1218.079664] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 1218.079669] rtlwifi: reg 0xc4c, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed545b78
[ 1218.079676] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 1218.079682] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[ 1218.079687] rtlwifi: reg 0xc94, usbctrl_vendorreq TimeOut! status:0xfffffff4
value=0xed545b78
[ 1218.241190] ADDRCONF(NETDEV_UP): wlan1: link is not ready

for the firmware i don't know how to update it, i'm using ubuntu 11.04 natty
with 3.1.0-0301rc9-generic
where can i download updated firmware to test it for this card?
thx



