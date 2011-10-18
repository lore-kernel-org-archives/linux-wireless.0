Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47553 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517Ab1JRMoT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:44:19 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RG91m-0008Ie-2h
	for linux-wireless@vger.kernel.org; Tue, 18 Oct 2011 14:44:18 +0200
Received: from host194-182-dynamic.1-87-r.retail.telecomitalia.it ([87.1.182.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 14:44:17 +0200
Received: from gaigo88 by host194-182-dynamic.1-87-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 14:44:17 +0200
To: linux-wireless@vger.kernel.org
From: v4mp <gaigo88@hotmail.it>
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
Date: Tue, 18 Oct 2011 12:44:02 +0000 (UTC)
Message-ID: <loom.20111018T143746-420@post.gmane.org> (sfid-20111018_144423_866952_2DB72868)
References: <4E77F631.3030202@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T1 61652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org> <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org> <4E9CF13A.7060102@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello,
i've tried blacklisting xhci_hcd driver but when i disable it can't read nothing
from usb, also the usb mouse doesn't work

the problem should be here, i think they are usb 3.0 ports
the lsusb listes correctly that a realtek is connected

Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 003: ID 0bda:817f Realtek Semiconductor Corp. 
Bus 003 Device 002: ID 093a:2510 Pixart Imaging, Inc. Optical Mouse
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 004: ID 0489:e00f Foxconn / Hon Hai 
Bus 001 Device 003: ID 064e:2100 Suyin Corp. 
Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

thx





