Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46936 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0IJL3g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 07:29:36 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Ou1nS-00049p-5R
	for linux-wireless@vger.kernel.org; Fri, 10 Sep 2010 13:29:34 +0200
Received: from 217.110.62.222 ([217.110.62.222])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 13:29:34 +0200
Received: from claus.ried by 217.110.62.222 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 13:29:34 +0200
To: linux-wireless@vger.kernel.org
From: Claus Ried <claus.ried@gmail.com>
Subject: Re: Realtek rtl8188 support?
Date: Fri, 10 Sep 2010 11:29:25 +0000 (UTC)
Message-ID: <loom.20100910T132509-455@post.gmane.org>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>  <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>  <1267949782.15192.13.camel@mj>  <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com> <1268190973.10669.12.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@...> writes:

> 
> On Sun, 2010-03-07 at 16:36 +0100, Gábor Stefanik wrote:
> 
> > Maybe with an actual RTL8192SU firmware it would work... just my 2 HUF.
> 
> Actually, you are absolutely right!  The driver is working fine with the
> firmware from rtl8192su_linux_2.6.0002.0708.2009.tar.gz
> 
> CCMP is working, and I could browse the web over it!
> 


Hi,

i have the same problems with an rtl8188su based usb wlan stick running on an
amd64 based mandriva 2.6.33 kernel. The current staging drivers (inlcuding the
firmware) do work to some extent, scanning is ok, listing surrounding wlans is
working.
But, i cannot connect to my wpa2 encrypted network using this stick.
Everything is working fine if i am using the internal laptop wlan card (intel
based).
Any ideas why the usb stick won't connect?
Claus

