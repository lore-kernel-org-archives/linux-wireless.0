Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab2G0PPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 11:15:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SumFw-0004mz-23
	for linux-wireless@vger.kernel.org; Fri, 27 Jul 2012 17:15:08 +0200
Received: from 83.68.239.193 ([83.68.239.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 17:15:08 +0200
Received: from netuse by 83.68.239.193 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 17:15:08 +0200
To: linux-wireless@vger.kernel.org
From: Marco <netuse@lavabit.com>
Subject: RTL8187 in master mode with hostapd
Date: Fri, 27 Jul 2012 17:11:37 +0200
Message-ID: <20120727171137.4a1d1ce7@homerow> (sfid-20120727_171516_140532_CE69FA1A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I own an Alfa AWUS036H network adapter using the rtl8187 driver on a
Debian box running kernel 3.5.0. I want to use it with hostapd, which
apparently requires master mode to be enabled in the driver.

The page http://linuxwireless.org/en/users/Drivers/rtl8187 states:

  not working yet: AP/Master mode

What means *yet*? Is it planned to add master mode support in the
near future? Do you have other suggestions what I could do to get
the driver to work together with hostap?

Disclaimer: I am not an expert in those things. I set up the access
point some years ago, then the network adapter started to function
unreliably. I then replaced it with a different one (the
abovementioned 036H) and didn't manage to get my setup running
again.


Best regards

Marco


