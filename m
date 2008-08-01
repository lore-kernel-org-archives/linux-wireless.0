Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41339 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbYHATE7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 15:04:59 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KOzvo-0005tH-Ql
	for linux-wireless@vger.kernel.org; Fri, 01 Aug 2008 19:04:52 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 19:04:52 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 19:04:52 +0000
To: linux-wireless@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Date: Fri, 1 Aug 2008 19:04:43 +0000 (UTC)
Message-ID: <g6vmoa$3lc$2@ger.gmane.org> (sfid-20080801_210503_844658_38AF6E15)
References: <4891D1B9.70703@imap.cc>
	<1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc>
	<20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-usb@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 01 Aug 2008 00:13:49 +0200, Tilman Schmidt wrote:

> So as soon as the AVM driver switches the stick from storage mode (where
> it offers Windows drivers for installation) to WLAN mode, the acx module
> shows up.

If it still uses acx in some way, an ACX chipset is involved, so any free 
or open driver for the device would be one that handles those. Now, you 
have some research to do.

