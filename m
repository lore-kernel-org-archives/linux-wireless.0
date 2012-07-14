Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42495 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab2GNU2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 16:28:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Sq8wv-0004QE-KU
	for linux-wireless@vger.kernel.org; Sat, 14 Jul 2012 22:28:21 +0200
Received: from 83.101.52.197 ([83.101.52.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jul 2012 22:28:21 +0200
Received: from not0read0765 by 83.101.52.197 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jul 2012 22:28:21 +0200
To: linux-wireless@vger.kernel.org
From: Olive <not0read0765@yopmail.com>
Subject: Re: rt73usb not working since linux 3.4
Date: Sat, 14 Jul 2012 22:28:11 +0200
Message-ID: <20120714222811.0422834c@yopmail.com> (sfid-20120714_222828_018139_9219B474)
References: <1364831.ftJE0YjeaD@proton>
	<20120711185026.657d7786@yopmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> I have the same problem with a rt73usb too and with the
> kernel 3.4.4-2-ARCH (Archlinux). The solution was to recompile the
> kernel with the option CONFIG_RFKILL unset (really unset not as a
> module). Then everything works properly (exept you cannot disable it
> with rfkill). I did not had this problem before the kernel 3.4 (but I
> do not know if rfkill actually works, or if the wlan was always
> enabled).

The strange thing is that after having disabled the CONFIG_RFKIL , the
wireless works even if I physically put a physical switch in the off
position. Anyway I prefer having a wireless card that works whgen it
shouldn't than vice versa.

Olive


